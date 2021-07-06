// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _RestClient implements RestClient {
  _RestClient(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    this.baseUrl ??= 'https://dev.kaspontech.com/djadmin/';
  }

  final Dio _dio;

  String baseUrl;

  @override
  login(body) async {
    ArgumentError.checkNotNull(body, 'body');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body ?? <String, dynamic>{});
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'customer_login/',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = OuterResponse.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  register(body) async {
    ArgumentError.checkNotNull(body, 'body');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body ?? <String, dynamic>{});
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'customer_registration/',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = RegisterResponse.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  emailVerify(body) async {
    ArgumentError.checkNotNull(body, 'body');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body ?? <String, dynamic>{});
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'cus_validation/',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = EmailResponse.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  resetPassword(body) async {
    ArgumentError.checkNotNull(body, 'body');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body ?? <String, dynamic>{});
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'customer_forget_password/',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = ResetPasswordResponse.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  mobileVerify(body) async {
    ArgumentError.checkNotNull(body, 'body');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body ?? <String, dynamic>{});
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'cus_validation/',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = MobileResponse.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  postTokenActivity(body) async {
    ArgumentError.checkNotNull(body, 'body');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body ?? <String, dynamic>{});
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'customer_token/',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = TokenResponse.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  editProfile(token, body) async {
    ArgumentError.checkNotNull(body, 'body');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body ?? <String, dynamic>{});
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'edit_customer_details/',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{'Token': token.toString()},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = RegisterResponse.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  getProfile(token, customerCode) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    Map<String, String> requestHeaders = {'Token': token};
    Map<String, String> queryParams = {
      'customer_code': customerCode.toString()
    };
    String queryString = Uri(queryParameters: queryParams).query;
    final Response<Map<String, dynamic>> _result = await _dio.get(
        'customer_profile/' + '?' + queryString,
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{'Token': token.toString()},
            extra: _extra,
            baseUrl: baseUrl));

    final value = ProfileResponse.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  getCountry() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'get_country/',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = CountryResponse.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  getCity(stateId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    Map<String, String> queryParams = {'state_id': stateId.toString()};
    String queryString = Uri(queryParameters: queryParams).query;
    final Response<Map<String, dynamic>> _result = await _dio.get(
        'get_city/' + '?' + queryString,
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl));
    final value = CityResponse.fromJson(_result.data);
    return Future.value(value);
  }

  getMyProductList(token, email) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    Map<String, String> queryParams = {'email': email.toString()};
    String queryString = Uri(queryParameters: queryParams).query;
    final Response<Map<String, dynamic>> _result = await _dio.get(
        'my_products/' + '?' + queryString,
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{'Token': token.toString()},
            extra: _extra,
            baseUrl: baseUrl));
    final value = MyProductListResponse.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  getLocation(cityId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    Map<String, String> queryParams = {'city_id': cityId.toString()};
    String queryString = Uri(queryParameters: queryParams).query;
    final Response<Map<String, dynamic>> _result = await _dio.get(
        'get_location_details/' + '?' + queryString,
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl));
    final value = LocationResponse.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  getSubProduct(productId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    Map<String, String> queryParams = {'product_id': productId.toString()};
    String queryString = Uri(queryParameters: queryParams).query;
    final Response<Map<String, dynamic>> _result = await _dio.get(
        'get_subproduct_details/' + '?' + queryString,
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl));
    final value = SubProductResponse.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  getProduct() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'get_product_details/',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = ProductResponse.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  getAmcDetails() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'get_amc_details/',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = AmcResponse.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  Future<StateResponse> getState(int countryId) async {
    Map<String, String> queryParams = {'country_id': countryId.toString()};
    String queryString = Uri(queryParameters: queryParams).query;
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final Response<Map<String, dynamic>> _result = await _dio.get(
        'get_state/' + '?' + queryString,
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl));
    final value = StateResponse.fromJson(_result.data);
    return Future.value(value);
  }
}
