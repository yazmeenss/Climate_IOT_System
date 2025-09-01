
#include <Arduino.h>
#if defined(ESP32)
  #include <WiFi.h>
#elif defined(ESP8266)
  #include <ESP8266WiFi.h>
#endif
#include <Firebase_ESP_Client.h>
#include "addons/TokenHelper.h"
#include "addons/RTDBHelper.h"
#define WIFI_SSID "realme 6 Pro"
#define WIFI_PASSWORD "nada1234"
#define API_KEY "AIzaSyDNJc4S7Lcv2WLadb34x30lYFHPIArSDlY"
#define DATABASE_URL "https://article-2889d-default-rtdb.europe-west1.firebasedatabase.app/" 
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;
unsigned long sendDataPrevMillis = 0;
int count = 0;
bool signupOK = false;


#include "DHT.h"
#define DHTPIN 4     // Digital pin connected to the DHT sensor
#define SensorPin 36
float Moisture;
#define DHTTYPE DHT22   // DHT 22  (AM2302), AM2321

DHT dht(DHTPIN, DHTTYPE);



void setup(){
  Serial.begin(9600);

  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED){
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();
  config.api_key = API_KEY;
  config.database_url = DATABASE_URL;
  if (Firebase.signUp(&config, &auth, "", "")){
    Serial.println("ok");
    signupOK = true;
  }
  else{
    Serial.printf("%s\n", config.signer.signupError.message.c_str());
  }
  config.token_status_callback = tokenStatusCallback;
  
  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);

  pinMode(2, OUTPUT);
  dht.begin();


}

void loop(){
  if (Firebase.ready() && signupOK && (millis() - sendDataPrevMillis > 15000 || sendDataPrevMillis == 0)){
    sendDataPrevMillis = millis();
   
  
  Moisture = (4095-analogRead(SensorPin));
  int precentage = (Moisture/4095) * 100;
   Serial.print(Moisture);
  Serial.print("Moisture precentage = ");
  Serial.print(precentage);
  Serial.println("%");
  
 

  float h = dht.readHumidity();
  float t = dht.readTemperature();
  Serial.print(F("Humidity: "));
  Serial.print(h);
  Serial.print(F("%  Temperature: "));
  Serial.print(t);
  Serial.print(F("°C "));
    if (Firebase.RTDB.setInt(&fbdo, "test/temp", t)){
      Serial.println("PASSED");
      
    }
    else {
      Serial.println("FAILED");
      Serial.println("REASON: " + fbdo.errorReason());
    }
    if (Firebase.RTDB.setInt(&fbdo, "test/humidity", h)){
      Serial.println("PASSED");
      
    }
    else {
      Serial.println("FAILED");
      Serial.println("REASON: " + fbdo.errorReason());
    }
    if (Firebase.RTDB.setInt(&fbdo, "test/moisure", precentage)){
      Serial.println("PASSED");
     
    }
    else {
      Serial.println("FAILED");
      Serial.println("REASON: " + fbdo.errorReason());
    }
    
    
  }
}