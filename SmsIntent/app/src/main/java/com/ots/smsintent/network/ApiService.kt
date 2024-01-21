package com.ots.smsintent.network

import com.ots.smsintent.data.LocationData
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.converter.scalars.ScalarsConverterFactory
import retrofit2.http.Body
import retrofit2.http.POST


private const val BASE_URL =
    "https://dummy.restapiexample.com/api/v1/"

private val retrofit = Retrofit.Builder()
    .addConverterFactory(ScalarsConverterFactory.create())
    .baseUrl(BASE_URL)
    .build()

interface ApiService {
    @POST("saveLocation")
     suspend fun sendLocationData(@Body postData: LocationData): Response<Any>
}

object LocationApi{
    val retrofitService: ApiService by lazy {
        retrofit.create(ApiService::class.java)
    }
}