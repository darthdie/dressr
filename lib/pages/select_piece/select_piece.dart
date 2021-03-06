import 'package:built_collection/built_collection.dart';
import 'package:dressr/app_state.dart';
import 'package:dressr/models/accessory.dart';
import 'package:dressr/models/piece.dart';
import 'package:dressr/models/shirt.dart';
import 'package:dressr/widgets/piece_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:redux/redux.dart';
import 'package:cupertino_segment_control/cupertino_segment_control.dart';

enum SelectPieceFilter {
  All,
  Shirts,
  Accessories
}

class PieceHeaderTile extends StatelessWidget {

  final String title;
  final String subtitle;
  final IconData icon;
  final Function onPressed;

  const PieceHeaderTile({Key key, this.title, this.subtitle, this.icon, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      dense: true,
      leading: new Icon(icon),
      title: new Text(title, style: Theme.of(context).textTheme.title,),
      subtitle: new Text(subtitle),
      trailing: new IconButton(
        icon: const Icon(Icons.add),
        onPressed: onPressed
      ),
    );
  }
}

class SelectPieceModal extends StatelessWidget {
  void _selectPiece(BuildContext context, Piece piece) {
    Navigator.pop(context, piece.id);
  }

  List<Widget> _buildShirts(BuildContext context, _SelectPieceModalViewModel viewModel) {
    if (viewModel.filter != SelectPieceFilter.All && viewModel.filter != SelectPieceFilter.Shirts) {
      return [];
    }

    return <Widget>[
      new PieceHeaderTile(
        title: 'Shirts',
        subtitle: '${viewModel.shirts.length} Shirt',
        icon: FontAwesomeIcons.tshirt,
        onPressed: () {
        },
      ),
      const Divider()
    ]
    ..addAll(viewModel.shirts.map((s) => new PieceTile(piece: s, onPressed: () => _selectPiece(context, s),)))
    ..toList();
  }

  List<Widget> _buildAccessories(BuildContext context, _SelectPieceModalViewModel viewModel) {
    if (viewModel.filter != SelectPieceFilter.All && viewModel.filter != SelectPieceFilter.Accessories) {
      return [];
    }

    return <Widget>[
        new PieceHeaderTile(
        title: 'Accessories',
        subtitle: '${viewModel.accessories.length} Accessories',
        icon: FontAwesomeIcons.blackTie,
        onPressed: () {
        },
      ),
      const Divider()
    ]
    ..addAll(viewModel.accessories.map((a) => new PieceTile(piece: a, onPressed: () => _selectPiece(context, a))))
    ..toList();
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _SelectPieceModalViewModel>(
      converter: (store) => new _SelectPieceModalViewModel.create(store),
      distinct: true,
      builder: (context, viewModel) {
        final items = _buildShirts(context, viewModel)
        ..addAll(_buildAccessories(context, viewModel));

        return new Scaffold(
          appBar: new AppBar(
            title: const Text('Select Piece'),
          ),
          body: new Column(
            children: <Widget>[
              new SizedBox(height: 12.0,),
              new SegmentControl([
                  new SegmentControlItem('All', const Text('All')),
                  new SegmentControlItem('Shirts', const Text('Shirts')),
                  new SegmentControlItem('Accessories', const Text('Accessories')),
                ],
                onChange: (index) => viewModel.changeFilter(SelectPieceFilter.values[index]),
                color: Theme.of(context).primaryColor,
                activeTabIndex: viewModel.filter.index,
              ),
              const Divider(),
              new Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: new TextField(
                  decoration: new InputDecoration(
                    hintText: 'Search...',
                    icon: const Icon(Icons.search),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) => viewModel.changeSearchFilter(value),
                ),
              ),
              const Divider(),
              new Expanded(child: new ListView(children: items))
            ],
          ),
        );
      },
    );
  }
}

class _SelectPieceModalViewModel {
  _SelectPieceModalViewModel({
    this.shirts,
    this.accessories,
    this.changeFilter,
    this.filter,
    this.searchFilter,
    this.changeSearchFilter,
  });

  final BuiltList<Shirt> shirts;
  final BuiltList<Accessory> accessories;
  final Function changeFilter;
  final SelectPieceFilter filter;
  final String searchFilter;
  final ChangeSearchFilterCallback changeSearchFilter;

  factory _SelectPieceModalViewModel.create(Store<AppState> store) {
    return new _SelectPieceModalViewModel(
      shirts: filterPieces(store, store.state.shirts),
      accessories: filterPieces(store, store.state.accessories),
      changeFilter: (filter) => store.dispatch(new SelectPieceFilterAction(filter)), 
      filter: store.state.selectPieceFilter,
      searchFilter: store.state.selectPieceSearchFilter,
      changeSearchFilter: (filter) => store.dispatch(new UpdateSelectPieceSearchFilter(filter)),
    );
  }

  static BuiltList<Piece> filterPieces(Store<AppState> store, BuiltList<Piece> source) {
    return source.rebuild((b) => b..where((p) {
      return !store.state.outfits.current.pieces.contains(p.id) &&
      store.state.selectPieceSearchFilter.isEmpty || p.name.contains(store.state.selectPieceSearchFilter);
    }));
  }

  @override
  operator ==(o) =>
    identical(o, this) ||
    o is _SelectPieceModalViewModel &&
    shirts == o.shirts &&
    accessories == o.accessories &&
    filter == o.filter &&
    searchFilter == o.searchFilter;

  @override
  int get hashCode =>
    shirts.hashCode ^
    accessories.hashCode ^
    filter.hashCode ^
    searchFilter.hashCode;
}

typedef ChangeSearchFilterCallback = Function(String);