//////////////////////////////////////////////////////////////////////////////////////////
//                                                                                      //
//        ,-.              ;-.          This file is part of OpenPie.                   //
//      /   \             |  ) o                                                        //
//     |   | ;-. ,-. ;-. |-'  . ,-.     This software may be modified and distributed   //
//    \   / | | |-' | | |    | |-'      under the terms of the MIT license.             //
//    `-'  |-' `-' ' ' '    ' `-'       See the LICENSE file for details.               //
//        '                                                                             //
//////////////////////////////////////////////////////////////////////////////////////////

#ifndef OPENPIE_LIB_LOGGER_HPP
#define OPENPIE_LIB_LOGGER_HPP

#include <iosfwd>
#include <string>

namespace OpenPie {

//////////////////////////////////////////////////////////////////////////////////////////
// Prints beautiful messages to the console output.                                     //
//////////////////////////////////////////////////////////////////////////////////////////

class Logger {

 public:
  const static std::string PRINT_RED;
  const static std::string PRINT_GREEN;
  const static std::string PRINT_YELLOW;
  const static std::string PRINT_BLUE;
  const static std::string PRINT_PURPLE;
  const static std::string PRINT_TURQUOISE;

  const static std::string PRINT_RED_BOLD;
  const static std::string PRINT_GREEN_BOLD;
  const static std::string PRINT_YELLOW_BOLD;
  const static std::string PRINT_BLUE_BOLD;
  const static std::string PRINT_PURPLE_BOLD;
  const static std::string PRINT_TURQUOISE_BOLD;

  const static std::string PRINT_BOLD;
  const static std::string PRINT_RESET;

  static bool m_printFile;
  static bool m_printLine;

  static bool m_enableTrace;   // If any one of these
  static bool m_enableDebug;   // is set to false,
  static bool m_enableMessage; // the corresponding
  static bool m_enableWarning; // messages are discarded.
  static bool m_enableError;

  // you do not have to use these, the macros below are more easy to use
  static std::ostream& traceImpl(const char* file, int line);
  static std::ostream& debugImpl(const char* file, int line);
  static std::ostream& messageImpl(const char* file, int line);
  static std::ostream& warningImpl(const char* file, int line);
  static std::ostream& errorImpl(const char* file, int line);
};

} // namespace OpenPie

// Use these macros in your code like this:
// OPENPIE_MESSAGE << "hello world" << std::endl;
#define OPENPIE_TRACE OpenPie::Logger::traceImpl(__FILE__, __LINE__)
#define OPENPIE_DEBUG OpenPie::Logger::debugImpl(__FILE__, __LINE__)
#define OPENPIE_MESSAGE OpenPie::Logger::messageImpl(__FILE__, __LINE__)
#define OPENPIE_WARNING OpenPie::Logger::warningImpl(__FILE__, __LINE__)
#define OPENPIE_ERROR OpenPie::Logger::errorImpl(__FILE__, __LINE__)

#endif // OPENPIE_LIB_LOGGER_HPP
