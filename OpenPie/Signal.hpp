//////////////////////////////////////////////////////////////////////////////////////////
//                                                                                      //
//        ,-.              ;-.          This file is part of OpenPie.                   //
//      /   \             |  ) o                                                        //
//     |   | ;-. ,-. ;-. |-'  . ,-.     This software may be modified and distributed   //
//    \   / | | |-' | | |    | |-'      under the terms of the MIT license.             //
//    `-'  |-' `-' ' ' '    ' `-'       See the LICENSE file for details.               //
//        '                                                                             //
//////////////////////////////////////////////////////////////////////////////////////////

#ifndef OPENPIE_SIGNAL_HPP
#define OPENPIE_SIGNAL_HPP

#include <functional>
#include <map>

namespace OpenPie {

//////////////////////////////////////////////////////////////////////////////////////////
// A signal object may call multiple slots with the same signature. You can connect     //
// functions to the signal which will be called when the emit() method is invoked.      //
// Any argument passed to emit() will be passed to the given functions.                 //
//////////////////////////////////////////////////////////////////////////////////////////

template <typename... Args>
class Signal {

 public:
  Signal()
    : m_currentID(0) {}

  // Copy creates new signal
  Signal(Signal const& other)
    : m_currentID(0) {}

  // Connects a member function to this Signal
  template <typename T>
  int connectMember(T* inst, void (T::*func)(Args...)) {
    return connect([=](Args... args) { (inst->*func)(args...); });
  }

  // Connects a const member function to this Signal
  template <typename T>
  int connectMember(T* inst, void (T::*func)(Args...) const) {
    return connect([=](Args... args) { (inst->*func)(args...); });
  }

  // Connects a std::function to the signal. The returned
  // value can be used to disconnect the function again
  int connect(std::function<void(Args...)> const& slot) const {
    m_slots.insert(std::make_pair(++m_currentID, slot));
    return m_currentID;
  }

  // Disconnects a previously connected function
  void disconnect(int id) const { m_slots.erase(id); }

  // Disconnects all previously connected functions
  void disconnectAll() const { m_slots.clear(); }

  // Calls all connected functions
  void emit(Args... p) {
    for (auto it : m_slots) {
      it.second(p...);
    }
  }

  // Assignment creates new Signal
  Signal& operator=(Signal const& other) { disconnectAll(); }

 private:
  mutable std::map<int, std::function<void(Args...)>> m_slots;
  mutable int                                         m_currentID;
};

} // namespace OpenPie

#endif // OPENPIE_SIGNAL_HPP
