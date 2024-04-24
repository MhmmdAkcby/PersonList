import 'package:flutter/material.dart';
import 'package:person_list/core/project_colors.dart';
import 'package:person_list/model/post_model.dart';
import 'package:person_list/services/post_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<PostModel>? _items;
  bool _isLoading = false;
  late final IPostService _postService;
  final String appbarName = 'Person List';

  @override
  void initState() {
    super.initState();
    _postService = PostService();
    fetchPostItemsAdvance();
  }

  void _changeLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  Future<void> fetchPostItemsAdvance() async {
    _changeLoading();

    _items = await _postService.fetchPostItemsAdvance();
    _changeLoading();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appbarName,
          style: const TextStyle(color: ProjectColors.whiteColor),
        ),
        actions: [
          _isLoading
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator.adaptive(),
                )
              : const SizedBox.shrink()
        ],
      ),
      body: _items == null
          ? const Center(child: CircularProgressIndicator.adaptive())
          : ListView.builder(
              itemCount: _items?.length ?? 0,
              itemBuilder: (context, index) {
                return _PostCards(model: _items![index]);
              },
            ),
    );
  }
}

class _PostCards extends StatelessWidget {
  const _PostCards({
    super.key,
    required PostModel? model,
  }) : _model = model;

  final PostModel? _model;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text("${_model?.firstName ?? ''}  ${_model?.lastName ?? ''} "),
        subtitle: Text(_model?.email ?? ''),
        leading: CircleAvatar(backgroundImage: NetworkImage(_model?.avatar ?? '')),
      ),
    );
  }
}
