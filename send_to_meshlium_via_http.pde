
#include <WaspWIFI_PRO_V3.h>
#include <WaspFrame.h>
#include <WaspSensorSW.h>

// choose socket (SELECT USER'S SOCKET)
uint8_t socket = SOCKET0;

// choose HTTP server settings
char type[] = "http";
char host[] = "82.78.81.178";
uint16_t port = 80;

uint8_t error;
uint8_t status;

// define the Waspmote ID
char moteID[] = "VictoriaButuruga";

float value_pH;
float value_temp;
float value_pH_calculated;


// Calibration values
#define cal_point_10 1.985
#define cal_point_7 2.070
#define cal_point_4 2.227
// Temperature at which calibration was carried out
#define cal_temp 23.7
// Offset obtained from sensor calibration
#define calibration_offset 0.0

// Value 1 used to calibrate the sensor
#define point1_cond 10500
// Value 2 used to calibrate the sensor
#define point2_cond 40000
// Point 1 of the calibration 
#define point1_cal 197.00
// Point 2 of the calibration 
#define point2_cal 150.00


pHClass pHSensor;
pt1000Class TemperatureSensor;

void setup()
{
  USB.ON();
  USB.println(F("Frame Utility Example for Smart Water"));
  USB.println(F("******************************************************"));
  USB.println(F("WARNING: This example is valid only for Waspmote v15"));
  USB.println(F("If you use a Waspmote v12, you MUST use the correct "));
  USB.println(F("sensor field definitions"));
  USB.println(F("******************************************************"));

  // Set the Waspmote ID
  frame.setID(moteID);

  // Configure the calibration values
  pHSensor.setCalibrationPoints(cal_point_10, cal_point_7, cal_point_4, cal_temp);
}

void loop()
{
  
  // 1. Turn on the board
  

  Water.ON();
  delay(2000);

  
  // 2. Read sensors
  ///////////////////////////////////////////

  // Read the pH sensor
  value_pH = pHSensor.readpH();
  // Read the temperature sensor
  value_temp = TemperatureSensor.readTemperature();
  // Convert the value read with the information obtained in calibration
  value_pH_calculated = pHSensor.pHConversion(value_pH, value_temp);

  ///////////////////////////////////////////
  // 3. Turn off the sensors
  //////////////////////////////////////////Apologies for the incomplete response. Here's the corrected code:


   Water.OFF();

  ///////////////////////////////////////////
  // 4. Create ASCII frame
  ///////////////////////////////////////////

  // Create new frame (ASCII)
  frame.createFrame(ASCII);

  // Add temperature
  frame.addSensor(SENSOR_WATER_WT, value_temp);
  // Add pH
  frame.addSensor(SENSOR_WATER_PH, value_pH_calculated);
  //Add Battery Level
  frame.addSensor(SENSOR_STR, "this_is_a_string");
  frame.addSensor(SENSOR_BAT, PWR.getBatteryLevel());

  // Show the frame
  frame.showFrame();

  // Wait for 2 seconds
  delay(2000);

  ///////////////////////////////////////////
  // 5. Send Frame to Meshlium
  ///////////////////////////////////////////

  // Switch ON the WiFi module
  error = WIFI_PRO_V3.ON(socket);

  if (error == 0)
  {
    USB.println(F("WiFi switched ON"));
  }
  else
  {
    USB.println(F("WiFi did not initialize correctly"));
  }

  // Check connectivity
  status = WIFI_PRO_V3.isConnected();

  // Check if module is connected
  if (status == true)
  {
    // Send the frame to Meshlium
    error = WIFI_PRO_V3.sendFrameToMeshlium(type, host, port, frame.buffer, frame.length);

    // Check response
    if (error == 0)
    {
      USB.println(F("Send frame to Meshlium done"));
    }
    else
    {
      USB.println(F("Error sending frame"));
      if (WIFI_PRO_V3._httpResponseStatus)
      {
        USB.print(F("HTTP response status: "));
        USB.println(WIFI_PRO_V3._httpResponseStatus);
      }
    }
  }
  else
  {
    USB.println(F("WiFi is not connected"));
  }

  // Switch OFF the WiFi module
  WIFI_PRO_V3.OFF(socket);
  USB.println(F("WiFi switched OFF\n\n"));

  // Delay for 10 seconds before next iteration
  delay(10000);
}
