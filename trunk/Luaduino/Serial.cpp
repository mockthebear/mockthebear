/*----------------------------------------------------
Original Serial lib for c++ can be found here:
http://www.arduino.cc/playground/Interfacing/CPPWindows

This one has been modified to work fine.
*/

#include "SerialClass.h"
using namespace std;
Serial::Serial(char *portName)
{
    //We're not yet connected
    this->connected = false;

    //Try to connect to the given port throuh CreateFile
    this->hSerial = CreateFile(portName,
            GENERIC_READ | GENERIC_WRITE,
            0,
            NULL,
            OPEN_EXISTING,
            FILE_ATTRIBUTE_NORMAL,
            NULL);

    //Check if the connection was successfull
    if(this->hSerial==INVALID_HANDLE_VALUE)
    {
        //If not success full display an Error
        if(GetLastError()==ERROR_FILE_NOT_FOUND){

            //Print Error if neccessary
            this->error = (char *)"ERROR: Handle was not attached. Reason: COM port not available.";

        }
        else
        {
            this->error = (char *)"UNKNOW ERROR!!!";
        }
    }
    else
    {
        //If connected we try to set the comm parameters
        DCB dcbCommPort = {0};

        //Try to get the current
        if (!GetCommState(this->hSerial, &dcbCommPort))
        {
            //If impossible, show an error
            this->error = (char *)("failed to get current serial parameters!");
        }
        else
        {
            //Define serial connection parameters for the arduino board
            COMMTIMEOUTS ctmoNew = {0}, ctmoOld;
            GetCommTimeouts(hSerial,&ctmoOld);
            ctmoNew.ReadTotalTimeoutConstant = 10;
            ctmoNew.ReadTotalTimeoutMultiplier = 0;
            ctmoNew.WriteTotalTimeoutMultiplier = 0;
            ctmoNew.WriteTotalTimeoutConstant = 0;
            SetCommTimeouts(hSerial, &ctmoNew);
            // SET BAUD RATE, PARITY, WORD SIZE, en STOP BITS.
            dcbCommPort.DCBlength = sizeof(DCB);
            GetCommState(hSerial, &dcbCommPort);
            BuildCommDCB("9600,N,8,1", &dcbCommPort);
            SetCommState(hSerial, &dcbCommPort);
             //Set the parameters and check for their proper application
             if(!SetCommState(hSerial, &dcbCommPort))
             {
                this->error = (char *)("ALERT: Could not set Serial Port parameters");
             }
             else
             {
                 //If everything went fine we're connected
                 this->connected = true;
                 this->error = (char *)"There is no errors :D";
                 //We wait 2s as the arduino board will be reseting
                 Sleep(ARDUINO_WAIT_TIME);
             }
        }
    }
}

Serial::~Serial()
{
    //Check if we are connected before trying to disconnect
    if(this->connected)
    {
        //We're no longer connected
        this->connected = false;
        //Close the serial handler
        CloseHandle(this->hSerial);
    }
}
int Serial::GetLenInQueue()
{
    ClearCommError(this->hSerial, &this->errors, &this->status);
    return this->status.cbInQue;
}
int Serial::ReadData(char *buffer, unsigned int nbChar)
{
    //Number of bytes we'll have read
    DWORD bytesRead;
    //Number of bytes we'll really ask to read
    unsigned int toRead;

    //Use the ClearCommError function to get status info on the Serial port
    ClearCommError(this->hSerial, &this->errors, &this->status);

    //Check if there is something to read
    if(this->status.cbInQue>0)
    {
        //If there is we check if there is enough data to read the required number
        //of characters, if not we'll read only the available characters to prevent
        //locking of the application.
        if(this->status.cbInQue>nbChar)
        {
            toRead = nbChar;
        }
        else
        {
            toRead = this->status.cbInQue;
        }

        //Try to read the require number of chars, and return the number of read bytes on success
        if(ReadFile(this->hSerial, buffer, toRead, &bytesRead,NULL))
        {
            return bytesRead;
        }

    }

    //If nothing has been read, or that an error was detected return -1
    return -1;

}


bool Serial::WriteData(char *buffer, unsigned int nbChar)
{
    DWORD bytesSend;

    //Try to write the buffer on the Serial port
    if(!WriteFile(this->hSerial, (void *)buffer, nbChar, &bytesSend, 0))
    {
        //In case it don't work get comm error and return false
        ClearCommError(this->hSerial, &this->errors, &this->status);

        return false;
    }
    else
        return true;
}

bool Serial::IsConnected()
{
    //Simply return the connection status
    return this->connected;
}

char *Serial::getErrorMessage()
{
    //Simply return the connection status
    return this->error;
}
