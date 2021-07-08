import 'package:dio/dio.dart';
import 'package:flutter_api_json_parse/network/response/amcListResponse.dart';
import 'package:flutter_api_json_parse/network/response/amcResponse.dart';
import 'package:flutter_api_json_parse/network/response/callCategoryResponse.dart';
import 'package:flutter_api_json_parse/network/response/cityResponse.dart';
import 'package:flutter_api_json_parse/network/response/emailResponse.dart';
import 'package:flutter_api_json_parse/network/response/locationResponse.dart';
import 'package:flutter_api_json_parse/network/response/mobileResponse.dart';
import 'package:flutter_api_json_parse/network/response/myProductListResponse.dart';
import 'package:flutter_api_json_parse/network/response/productResponse.dart';
import 'package:flutter_api_json_parse/network/response/profileResponse.dart';
import 'package:flutter_api_json_parse/network/response/registerResponse.dart';
import 'package:flutter_api_json_parse/network/response/resetPasswordResponse.dart';
import 'package:flutter_api_json_parse/network/response/stateResponse.dart';
import 'package:flutter_api_json_parse/network/response/countryResponse.dart';
import 'package:flutter_api_json_parse/network/response/global_response.dart';
import 'package:flutter_api_json_parse/network/response/login_response.dart';
import 'package:flutter_api_json_parse/network/response/subProductResponse.dart';
import 'package:flutter_api_json_parse/network/response/tokenResponse.dart';
import 'package:flutter_api_json_parse/utility/app_url.dart';
import 'package:retrofit/http.dart';

part 'api_service.g.dart';

// done this file

@RestApi(baseUrl: "https://dev.kaspontech.com/djadmin/")
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) {
    dio.options = BaseOptions(
        receiveTimeout: 30000,
        connectTimeout: 30000,
        headers: {'Content-Type': 'application/json'});

    return _RestClient(dio, baseUrl: baseUrl);
  }

  // Login service
  @POST('customer_login/')
  Future<OuterResponse> login(@Body() Map<String, dynamic> body);

  @POST('customer_registration/')
  Future<RegisterResponse> register(@Body() Map<String, dynamic> body);

  @POST("customer_amc/")
  Future<RegisterResponse> addAMC(String token, @Body() Map<String, dynamic> body);

  @POST('add_customer_product/')
  Future<RegisterResponse> addProduct(
      String token, @Body() Map<String, dynamic> body);

  @POST("cus_validation/")
  Future<EmailResponse> emailVerify(@Body() Map<String, dynamic> body);

  @POST("change_password/")
  Future<ResetPasswordResponse> changePassword(
      @Body() Map<String, dynamic> body);

  @POST("cus_validation/")
  Future<MobileResponse> mobileVerify(@Body() Map<String, dynamic> body);

  @POST("validate_serial_no/")
  Future<EmailResponse> validateSerialNo(@Body() Map<String, dynamic> body);

  @POST("customer_token/")
  Future<TokenResponse> postTokenActivity(@Body() Map<String, dynamic> body);

  @POST("customer_forget_password/")
  Future<ResetPasswordResponse> resetPassword(
      @Body() Map<String, dynamic> body);

  @POST("edit_customer_details/")
  Future<RegisterResponse> editProfile(
      String token, @Body() Map<String, dynamic> body);

  @POST("load_contract_details/")
  Future<AmcListResponse> amcList(
      String token, @Body() Map<String, dynamic> body);

  @GET('get_country/')
  Future<CountryResponse> getCountry();

  @GET("customer_profile/")
  Future<ProfileResponse> getProfile(String token, String customerCode);

  @GET('get_state/')
  Future<StateResponse> getState(int countryId);

  @GET('get_city/')
  Future<CityResponse> getCity(int stateId);

  @GET('get_location_details/')
  Future<LocationResponse> getLocation(int cityId);

  @GET('get_product_details/')
  Future<ProductResponse> getProduct();

  @GET('get_subproduct_details/')
  Future<SubProductResponse> getSubProduct(int productId);

  @GET('get_amc_details/')
  Future<AmcResponse> getAmcDetails();

  @GET('get_call_category/')
  Future<CallCategoryResponse> getCallCategory();

  @GET('my_products/')
  Future<MyProductListResponse> getMyProductList(String token, String email);
}
