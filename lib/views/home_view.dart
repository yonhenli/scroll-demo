import 'package:continuous_scroll/viewmodels/home_viewmodel.dart';
import 'package:continuous_scroll/widgets/creation_aware_list_item.dart';
import 'package:continuous_scroll/widgets/list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<HomeViewModel>(
        create: (context) => HomeViewModel(),
        child: Consumer<HomeViewModel>(
          builder: (context, model, child) => 
            RefreshIndicator(
              onRefresh: model.refresh,
              child: 
                ListView.builder(
                  itemCount: model.items.length + 1,
                  itemBuilder: (context, index) {
                    if (model.isLoading == false && index < model.items.length + 1) {
                      return CreationAwareListItem(
                        itemCreated: () {
                          SchedulerBinding.instance.addPostFrameCallback(
                              (duration) => model.loadMore(index));
                        },
                        child: ListItem(
                          title: model.items[index],
                        ),
                      );
                    }
                    else {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 32.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                  }
                )
            ),
        ),
      ),
    );
  }
}
