# Climate_IOT_System
IoT Climate & Agriculture Capstone Project

This is a STEM school capstone project that addresses the impact of climate change on agriculture in Egypt.  
We designed and built an IoT-based monitoring system to measure soil moisture, temperature, and humidity, then visualized this data in a mobile app with real-time graphs and a chatbot assistant for farmers.

The system helps raise awareness about drought risks and supports better agricultural practices.

---

Features:
- Hardware:
  - ESP32 microcontroller
  - Soil moisture sensor
  - DHT22 temperature & humidity sensor
- Wireless communication: (ESP32 → Firebase → Mobile App)
- Mobile Application:
  - Real-time graphs of sensor data
  - Animated UI for soil moisture, temperature, and humidity
  - Built-in chatbot for crop recommendations & weather queries
- Data Analysis:
  - Dynamic range & signal-to-noise ratio testing
  - Optimized for accuracy and reliability

---

Mobile App:
- Home Page: Displays real-time values of soil moisture, temperature, and humidity.  
- Graphs Page: Live-updating graphs showing relationships between variables.  
- Chatbot Page: Answers farmers’ questions about crop requirements and local weather.

  
---

Tech Stack:
- Hardware: ESP32, DHT22, Soil Moisture Sensor, Breadboard
- Software: Arduino IDE, Firebase, Flutter/Dart
- Programming Languages: C++ (for ESP32), Dart (for app)
- Other Tools: GitHub, Google Drive, Makers Electronics

---

Prototype Testing:
- Measured dynamic range of sensors for accuracy  
- Verified signal-to-noise ratio (≈ 36 dB, reliable data transmission)  
- Compared DHT11 vs DHT22 → DHT22 chosen for wider range & higher accuracy  

---

Impact:
- Helps farmers adapt to climate change by monitoring soil health in real-time.  
- Provides awareness and recommendations to improve crop yield.  
- Can be scaled with LoRa, GPS, and regional language support in the future.

---


