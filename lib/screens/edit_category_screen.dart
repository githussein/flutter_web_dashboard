import 'package:admin_panel_coupons/constants.dart';
import 'package:admin_panel_coupons/providers/categories_provider.dart';
import 'package:admin_panel_coupons/providers/category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/coupon.dart';
import '../providers/coupons_provider.dart';

class EditCategoryScreen extends StatefulWidget {
  static const routeName = '/edit-category';

  @override
  _EditCategoryScreenState createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  final _imageLinkController = TextEditingController();
  final _imageLinkFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _editedCategory = Category(
    id: null,
    title: '',
    imageUrl: '',
  );
  var _initValues = {
    'title': '',
    'imageUrl': '',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final couponId = ModalRoute.of(context).settings.arguments as String;
      if (couponId != null) {
        _editedCategory =
            Provider.of<CategoriesProvider>(context, listen: false)
                .findById(couponId);
        _initValues = {
          'title': _editedCategory.title,
          'imageUrl': '',
        };
        _imageLinkController.text = _editedCategory.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _imageLinkFocusNode.addListener(_updateImageLink);
    super.initState();
  }

  void _updateImageLink() {
    if (!_imageLinkFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _imageLinkFocusNode.removeListener(_updateImageLink);
    _imageLinkController.dispose();
    _imageLinkFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState.validate()) {
      //all fields are filled
      _formKey.currentState.save(); //execute every onSaved function

      //to show loading indicator
      setState(() {
        _isLoading = true;
      });

      //check weather to edit or add a new coupon
      if (_editedCategory.id != null) {
        try {
          //update provider
          await Provider.of<CategoriesProvider>(context, listen: false)
              .updateCategory(_editedCategory.id, _editedCategory);
        } catch (error) {
          await showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                    title: Text('خطأ في تعديل الصنف'),
                    content: Text('من فضلك تأكد من الإتصال بالانترنت'),
                    actions: [
                      MaterialButton(
                          child: Text('حسنا'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          })
                    ],
                  ));
        }
      } else {
        try {
          //update provider
          await Provider.of<CategoriesProvider>(context, listen: false)
              .addCategory(_editedCategory);
        } catch (error) {
          await showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                    title: Text(' خطأ في إضافة الصنف'),
                    content: Text('من فضلك تأكد من الاتصال بالانترنت'),
                    actions: [
                      MaterialButton(
                          child: Text('حسنا'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          })
                    ],
                  ));
        }
      }

      setState(() {
        _isLoading = true;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تعديل الأصناف'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: defaultPadding, horizontal: defaultPadding * 8),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: InputDecoration(labelText: 'اسم الصنف'),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'هذا الحقل إجباري';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          _editedCategory = Category(
                              id: _editedCategory.id,
                              title: value,
                              imageUrl: _editedCategory.imageUrl);
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(top: 8, right: 8),
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                            child: _imageLinkController.text.isEmpty
                                ? Text(' استعراض الصورة')
                                : FittedBox(
                                    child: Image.network(
                                        _imageLinkController.text),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          SizedBox(width: defaultPadding * 2),
                          Expanded(
                            child: TextFormField(
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.left,
                              // initialValue: _initValues['imageUrl'],
                              decoration:
                                  InputDecoration(labelText: '  رابط الصورة'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.next,
                              controller: _imageLinkController,
                              focusNode: _imageLinkFocusNode,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'هذا الحقل إجباري';
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (value) {
                                _editedCategory = Category(
                                    id: _editedCategory.id,
                                    title: _editedCategory.title,
                                    imageUrl: value);
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      MaterialButton(
                        onPressed: () {
                          _saveForm();
                        },
                        padding: EdgeInsets.symmetric(
                            vertical: defaultPadding,
                            horizontal: defaultPadding * 4),
                        color: Colors.green,
                        child: Text("حفظ التغييرات",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
