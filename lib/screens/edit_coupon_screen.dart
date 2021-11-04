import 'package:admin_panel_coupons/constants.dart';
import 'package:admin_panel_coupons/providers/categories_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/coupon.dart';
import '../providers/coupons_provider.dart';

class EditCouponScreen extends StatefulWidget {
  static const routeName = '/edit-coupon';

  @override
  _EditCouponScreenState createState() => _EditCouponScreenState();
}

class _EditCouponScreenState extends State<EditCouponScreen> {
  final _codeFocusNode = FocusNode();
  final _titleFocusNode = FocusNode();
  final _storeLinkFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageLinkController = TextEditingController();
  final _imageLinkFocusNode = FocusNode();
  final _categoryFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _editedCoupon = Coupon(
    id: null,
    store: '',
    title: '',
    code: '',
    description: '',
    imageUrl: '',
    link: '',
    category: 'all',
  );
  var _initValues = {
    'title': '',
    'store': '',
    'code': '',
    'description': '',
    'imageUrl': '',
    'link': '',
    'category': '',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final couponId = ModalRoute.of(context).settings.arguments as String;
      if (couponId != null) {
        _editedCoupon = Provider.of<CouponsProvider>(context, listen: false)
            .findById(couponId);
        _initValues = {
          'title': _editedCoupon.title,
          'store': _editedCoupon.store,
          'code': _editedCoupon.code,
          'description': _editedCoupon.description,
          // 'imageUrl': '_editedCoupon.imageUrl',
          'imageUrl': '',
          'link': _editedCoupon.link,
          'category': _editedCoupon.category,
        };
        _imageLinkController.text = _editedCoupon.imageUrl;
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
    _titleFocusNode.dispose();
    _codeFocusNode.dispose();
    _storeLinkFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageLinkController.dispose();
    _imageLinkFocusNode.dispose();
    _categoryFocusNode.dispose();
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
      if (_editedCoupon.id != null) {
        try {
          //update provider
          await Provider.of<CouponsProvider>(context, listen: false)
              .updateCoupon(_editedCoupon.id, _editedCoupon);
        } catch (error) {
          await showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                    title: Text('خطأ في تعديل الكوبون'),
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
          await Provider.of<CouponsProvider>(context, listen: false)
              .addCoupon(_editedCoupon);
        } catch (error) {
          await showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                    title: Text(' خطأ في إضافة كوبون'),
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
    //access the categories
    //instance of the categories provider
    final categoriesData = Provider.of<CategoriesProvider>(context).items;

    List<String> categoriesList = [];
    categoriesData.forEach((element) {
      categoriesList.insert(0, element.title);
    });

    String _category = '';

    return Scaffold(
      appBar: AppBar(
        title: Text('تعديل الكوبونات'),
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
                        initialValue: _initValues['store'],
                        decoration: InputDecoration(labelText: 'اسم المتجر'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_titleFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'هذا الحقل إجباري';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          _editedCoupon = Coupon(
                              id: _editedCoupon.id,
                              store: value,
                              title: _editedCoupon.title,
                              code: _editedCoupon.code,
                              description: _editedCoupon.description,
                              imageUrl: _editedCoupon.imageUrl,
                              link: _editedCoupon.link,
                              category: _editedCoupon.category,
                              isFavorite: _editedCoupon.isFavorite);
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: InputDecoration(labelText: 'اسم العرض'),
                        textInputAction: TextInputAction.next,
                        focusNode: _titleFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_codeFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'هذا الحقل إجباري';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          _editedCoupon = Coupon(
                              id: _editedCoupon.id,
                              store: _editedCoupon.store,
                              title: value,
                              code: _editedCoupon.code,
                              description: _editedCoupon.description,
                              imageUrl: _editedCoupon.imageUrl,
                              link: _editedCoupon.link,
                              category: _editedCoupon.category,
                              isFavorite: _editedCoupon.isFavorite);
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['code'],
                        decoration: InputDecoration(labelText: 'كود الخصم'),
                        textInputAction: TextInputAction.next,
                        focusNode: _codeFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'هذا الحقل إجباري';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          _editedCoupon = Coupon(
                              id: _editedCoupon.id,
                              store: _editedCoupon.store,
                              title: _editedCoupon.title,
                              code: value,
                              description: _editedCoupon.description,
                              imageUrl: _editedCoupon.imageUrl,
                              link: _editedCoupon.link,
                              category: _editedCoupon.category,
                              isFavorite: _editedCoupon.isFavorite);
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['description'],
                        decoration:
                            InputDecoration(labelText: 'تفاصيل الكوبون'),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusNode,
                        validator: (value) {
                          if (value.length < 5) {
                            return 'يرجى إدخال خمسة أحرف على الأقل';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          _editedCoupon = Coupon(
                              id: _editedCoupon.id,
                              store: _editedCoupon.store,
                              title: _editedCoupon.title,
                              code: _editedCoupon.code,
                              description: value,
                              imageUrl: _editedCoupon.imageUrl,
                              link: _editedCoupon.link,
                              category: _editedCoupon.category,
                              isFavorite: _editedCoupon.isFavorite);
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
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_storeLinkFocusNode);
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'هذا الحقل إجباري';
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (value) {
                                _editedCoupon = Coupon(
                                    id: _editedCoupon.id,
                                    store: _editedCoupon.store,
                                    title: _editedCoupon.title,
                                    code: _editedCoupon.code,
                                    description: _editedCoupon.description,
                                    imageUrl: value,
                                    link: _editedCoupon.link,
                                    category: _editedCoupon.category,
                                    isFavorite: _editedCoupon.isFavorite);
                              },
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        initialValue: _initValues['link'],
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(labelText: 'رابط المتجر'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.url,
                        focusNode: _storeLinkFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_categoryFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'هذا الحقل إجباري';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          _editedCoupon = Coupon(
                              id: _editedCoupon.id,
                              store: _editedCoupon.store,
                              title: _editedCoupon.title,
                              code: _editedCoupon.code,
                              description: _editedCoupon.description,
                              imageUrl: _editedCoupon.imageUrl,
                              link: value,
                              category: _editedCoupon.category,
                              isFavorite: _editedCoupon.isFavorite);
                        },
                      ),
                      DropdownButtonFormField<String>(
                        value: categoriesList[0] != null
                            ? categoriesList[0]
                            : null,
                        hint: Text('القسم'),
                        icon: const Icon(Icons.keyboard_arrow_down),
                        onChanged: (String newValue) {
                          setState(() {
                            _category = newValue;
                          });
                        },
                        items: categoriesList
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == null) {
                            return 'برجاء اختيار القسم';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedCoupon = Coupon(
                              id: _editedCoupon.id,
                              store: _editedCoupon.store,
                              title: _editedCoupon.title,
                              code: _editedCoupon.code,
                              description: _editedCoupon.description,
                              imageUrl: _editedCoupon.imageUrl,
                              link: _editedCoupon.link,
                              category: value,
                              isFavorite: _editedCoupon.isFavorite);
                        },
                      ),
                      // TextFormField(
                      //   initialValue: _initValues['category'],
                      //   decoration: InputDecoration(labelText: 'القسم'),
                      //   textInputAction: TextInputAction.done,
                      //   focusNode: _categoryFocusNode,
                      //   validator: (value) {
                      //     if (value.isEmpty) {
                      //       return 'هذا الحقل إجباري';
                      //     } else {
                      //       return null;
                      //     }
                      //   },
                      //   onSaved: (value) {
                      //     _editedCoupon = Coupon(
                      //         id: _editedCoupon.id,
                      //         store: _editedCoupon.store,
                      //         title: _editedCoupon.title,
                      //         code: _editedCoupon.code,
                      //         description: _editedCoupon.description,
                      //         imageUrl: _editedCoupon.imageUrl,
                      //         link: _editedCoupon.link,
                      //         category: value,
                      //         isFavorite: _editedCoupon.isFavorite);
                      //   },
                      // ),
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
