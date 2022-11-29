//
//  CommonDefine.h
//  BlueToothTest
//
//  Created by 王海燕 on 2022/10/13.
//

#ifndef CommonDefine_h
#define CommonDefine_h


#define BLE_SEND_MAX_LEN 20

#define NOTIFICATION_BLE_CONNECT    @"ble_connect"      //蓝牙连接
#define NOTIFICATION_BLE_DISCONNECT    @"ble_disconnect"      //蓝牙断开连接

typedef enum
{
    CMD_NOTIFICATION = 0x01,  // 通知类型
    CMD_CALL = 0x02,   // 调用类型
    CMD_RETURN = 0x03,  // 调用返回
}CmdType;


//struct BleCommond{
//    Byte cmd_type;// 命令类型
//    Byte cmd; // 命令
//    unsigned short len; // 数据长度，为16位整型，如果没有数据可以为0
//    void * data;// 命令携带的数据，长度由len确定
//};
////所有整型、浮点型都为小端模式。



//Call命令定义
enum CallCommondCode
{
    CorrectingCheck = 0x00,  // 是否校正
    GetStandardSamplesCount  = 0x01,   // 获取标样总数
    GetSamplesCount = 0x02,  // 获取试样总数
    GetDeviceModel = 0x03,  // 仪器型号
    GetDeviceSerialNo = 0x04,  // 获取仪器序列号
    GetHardwareVersion = 0x06,   //硬件版本
    GetSoftwareVersion = 0x07,   //软件版本
    GeteOpticalStructure = 0x011,   //获取光学结构
    GetWhiteboardNumber = 0x012,   //获取白板编号
    GetWhiteBoardReflectivity = 0x013,   //获取白板反射率
    GetStandardLightingSettings = 0x014,   //获取标准光源设置
    GetStandardObserverSettings = 0x015,   //获取标准观察者设置
    GetColorSpaceSettings = 0x018,   //获取颜色空间设置
    GetColorIndexSettings = 0x019,   //获取颜色指数设置
    GetColorDifferenceFormulaSettings = 0x020,   //获取色差公式设置
    GetCurrentTimeOfTheInstrument = 0x022,   //获取仪器当前时间
    
    SetWhiteboardNumber = 0x023,   //设置白板编号
    SetWhiteBoardReflectivity = 0x024,   //设置白板反射率
    SetStandardLighting = 0x025,   //设置标准光源
    SetStandardObserver = 0x026,   //设置标准观察者
    SetColorSpaceSettings = 0x029,   //设置颜色空间
    SetColorIndexSettings = 0x030,   //设置颜色指数
    SetColorDifferenceFormulaSettings = 0x031, //设置色差公式
    SetTolerance = 0x032,                      //设置容差
    SetCurrentTimeOfTheInstrument = 0x033,     //设置仪器当前时间
};


//NOTIFICATION命令定义
enum NotifyCommondCode
{
    InstrumentConnectedNotify  = 0x01,   // 告知仪器已连接告
    InstrumentdisConnectedNotify = 0x02,  // 知仪器断开连接
    CorrectingCheckNotify = 0x03,  // 校正
    MeasureNotify = 0x04,  // 测量
    SampleCountNotify = 0x05,   //获取标样关联的试样个数
    UploadStandardSamplesNotify = 0x06,   //上传标样
    UploadSamplesNotify = 0x07,   //上传试样
    InputStandardSamplesNotify = 0x08,   //输入标样
    DeleteStandardSamplesNotify = 0x09  //删除标样
};

//ReturnCommond命令定义
enum ReturnCommondCode
{
    CheckAndMeasure  = 0x01,   // 测量矫正
    AboutSample = 0x02,  // 关于标样和试样
};


//标准光源定义
enum StandardIlluminant
{
    D65 = 0,
    D50,
    A,
    C,
    D55,
    D75,
    F1,
    F2,
    F3,
    F4,
    F5,
    F6,
    F7,
    F8,
    F9,
    F10,
    F11,
    F12,
};


//标准观察者定义
enum StandardObserver
{
    DEGREE_2,  // 2度观察者角
    DEGREE_10,  // 10度观察者角
};

//SC模式定义
enum SC_MODE
{
    SCI         = 0,
    SCE         = 1,
    SCI_AND_SCE = 2, // I+E
};

//口径定义
enum CALIBER
{
    PHI_4    = 0,   // 4mm
    PHI_8    = 1,   // 8mm
};

//颜色空间定义
enum COLOR_SPACE
{
    COLOR_SPACE_CIELAB,        // CIE LAB
 COLOR_SPACE_HUNTERLAB,     // Hunter LAB
    COLOR_SPACE_CIEXYZ,        // CIE XYZ
 COLOR_SPACE_SRGB,          // sRGB
    COLOR_SPACE_CIEYxy,        // CIE Yxy
 COLOR_SPACE_MUNSELL,       // Munsell
    COLOR_SPACE_CIELCH,        // CIE LCh
 COLOR_SPACE_BETA_XY,       // βxy
    COLOR_SPACE_CIELUV,        // CIE Luv
    COLOR_SPACE_DIN_LAB99,     // DIN Lab99
    COLOR_SPACE_COUNT
};


//颜色指数定义
enum COLOR_INDEX
{
 INVALID,            //不选任何选项
 YELLOWNESS,         // 黄度指数
 WHITENESS,          // 白度指数
 STRENGTH,           // 力份
 METAMERISM_INDIEX,  // 同色异谱指数
 OPACITY,            // 遮盖度
 HUE_CLASSIFY_555,   //555色调分类
 STAINING_FASTNESS,  // 沾色牢度
    GARDER_INDEX,       //透射Garder指数
 COLOR_FASTNESS,     // 变色牢度
 PT_CO_INDEX,        //pt co指数
 GLOSS_8,            //8 度光泽度
};

//色差公式定义
enum  COLOR_DELTA_FORMULA
{
    CIEDE,      // ΔE*ab
    CIEDE94,    // ΔE*94
    CIEDE2000,  // ΔE*2000 ΔE*00
    DECMC21,    // ΔE*cmc(2:1)
    DECMC11,    // ΔE*cmc(1:1)
    DECMC,      // ΔE*cmc(l:c)
    CIEDUV,
    DIN_E99,    // DIN E99
    DEHUNTER,   // dE(Hunter)
};


//仪器时间日期定义
struct DateTime
{
    uint16_t year;
    Byte  month;
    Byte  date;
    Byte  hours;
    Byte  minutes;
    Byte  seconds;
};

//容差定义
typedef struct
{
    float dE;          // ΔE的容差
    float dL_Lower;    // L下限
    float da_Lower;    // a下限
    float db_Lower;    // b下限
    float dL_Upper;    // L上限
    float da_Upper;    // a上限
    float db_Upper;    // b上限
}Tolerance;


//struct tsFlashDegrees {
//    float S_i;
//    float S_a;
//    float S_G;
//    float G;
//};
//         

//struct ColorData {
//    uint16_t spectral_data[31];//乘以10000后的光谱数据，当记录的颜色数据类型为 @ref tsCOLOR_DATA_TYPE_SPECTRUM 时有效
//};

////标样定义
//struct StandardRecord {
//    Byte flags[8];          //记录标志位 (无用)
//    char number[10];       //标样编号
//    struct DateTime date_time; //采样日期
//    Byte reverse1;       //无用数据
//    uint16_t angles; //可用角度
//    struct ColorData sci[12]; // SCI下测量的数据,有12组光谱数据，每组光谱有31个数据, 各2byte, 所以每组共有2*31个byte. 使用小端整数来解析
//    struct Tolerance tolerance[12] ;//无用数据,可能是容差tolerance
//    struct tsFlashDegrees flash_degrees[6]; //彩闪度si sa sg G （6组颗粒度统一用第一组数据的颗粒度G）
//    Byte reserve[]; //保留字节，对齐到2048字节
//};



//typedef struct  ColorSpaceX{
//    double l;
//    double a;
//    double b;
//    double c;
//    double h;
//}colorspaceX;



#endif /* CommonDefine_h */


