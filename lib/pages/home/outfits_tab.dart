import 'package:built_collection/built_collection.dart';
import 'package:dressr/app_state.dart';
import 'package:dressr/models/outfit.dart';
import 'package:dressr/pages/add_outfit.dart';
import 'package:dressr/widgets/image_grid_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class OutfitsTab extends StatelessWidget {
  const OutfitsTab();

  void handleGridTileTapped(BuildContext context, _OutfitsTabViewModel viewModel, Outfit shirt) {
    // viewModel.selectShirt(shirt);
    // Navigator.push(context, new MaterialPageRoute(builder: (ctx) => new ShirtPage()));
  }

  List<Widget> _buildGridTiles(BuildContext context, _OutfitsTabViewModel viewModel) {
    return viewModel.outfits
    .map((outfit) => new ImageGridTile(path: outfit.image, onTap: () => handleGridTileTapped(context, viewModel, outfit)))
    .toList();
  }

  Widget _buildBody(BuildContext context, _OutfitsTabViewModel viewModel) {
    if (viewModel.outfits.isEmpty)  {
      return new Center(
        child: const Text("Your outfit collection is looking pretty small."),
      );
    }

    return new GridView.count(
      crossAxisCount: 4,
      padding: const EdgeInsets.all(8.0),
      crossAxisSpacing: 8.0,
      children: _buildGridTiles(context, viewModel)
    );
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _OutfitsTabViewModel>(
      distinct: true,
      converter: (store) => new _OutfitsTabViewModel.create(store),
      builder: (context, viewModel) {
        return new Scaffold(
          body: _buildBody(context, viewModel),
          floatingActionButton: new FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(context, new MaterialPageRoute(builder: (context) => new AddOutfitModal()));
            },
          ),
        );
      }
    );
  }
}

class _OutfitsTabViewModel {
  _OutfitsTabViewModel({
    this.outfits,
  });

  final BuiltList<Outfit> outfits;

  factory _OutfitsTabViewModel.create(Store<AppState> store) {
    return new _OutfitsTabViewModel(
      outfits: store.state.outfits
    );
  }
}