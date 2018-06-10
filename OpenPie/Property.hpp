//////////////////////////////////////////////////////////////////////////////////////////
//                                                                                      //
//        ,-.              ;-.          This file is part of OpenPie.                   //
//      /   \             |  ) o                                                        //
//     |   | ;-. ,-. ;-. |-'  . ,-.     This software may be modified and distributed   //
//    \   / | | |-' | | |    | |-'      under the terms of the MIT license.             //
//    `-'  |-' `-' ' ' '    ' `-'       See the LICENSE file for details.               //
//        '                                                                             //
//////////////////////////////////////////////////////////////////////////////////////////

#ifndef OPENPIE_PROPERTY_HPP
#define OPENPIE_PROPERTY_HPP

#include "Signal.hpp"

#include <iostream>

namespace OpenPie {

//////////////////////////////////////////////////////////////////////////////////////////
// A Property is a encpsulates a value and may inform you on any changes applied to     //
// this value.                                                                          //
//////////////////////////////////////////////////////////////////////////////////////////

template <typename T>
class Property {

 public:
  typedef T value_type;

  // Properties for built-in types are automatically initialized to 0. See template
  // spezialisations at the bottom of this file
  Property() {}

  Property(T const& val)
    : m_value(val) {}

  Property(T&& val)
    : m_value(std::move(val)) {}

  Property(Property<T> const& to_copy)
    : m_value(to_copy.m_value) {}

  Property(Property<T>&& to_copy)
    : m_value(std::move(to_copy.m_value)) {}

  // Returns a Signal which is fired when the internal value will be changed. The old
  // value is passed as parameter.
  virtual Signal<T> const& beforeChange() const { return m_beforeChange; }

  // Returns a Signal which is fired when the internal value has been changed. The new
  // value is passed as parameter.
  virtual Signal<T> const& onChange() const { return m_onChange; }

  // sets the Property to a new value. beforeChange() and onChange() will be emitted.
  virtual void set(T const& value) {
    if (value != m_value) {
      m_beforeChange.emit(m_value);
      m_value = value;
      m_onChange.emit(m_value);
    }
  }

  // Sets the Property to a new value. beforeChange() and onChange() will not be emitted
  void setWithNoEmit(T const& value) { m_value = value; }

  // Emits beforeChange() and onChange() even if the value did not change
  void touch() {
    m_beforeChange.emit(m_value);
    m_onChange.emit(m_value);
  }

  // Returns the internal value
  virtual T const& get() const { return m_value; }

  // Connects two Properties to each other. If the source's value is changed, this' value
  // will be changed as well
  virtual void connectFrom(Property<T> const& source) {
    disconnect();
    m_connection   = &source;
    m_connectionID = source.onChange().connect([this](T const& value) {
      set(value);
      return true;
    });
    set(source.get());
  }

  // If this Property is connected from another property, it will e disconnected
  virtual void disconnect() {
    if (m_connection) {
      m_connection->onChange().disconnect(m_connectionID);
      m_connectionID = -1;
      m_connection   = nullptr;
    }
  }

  // If there are any Properties connected to this Property, they won't be notified of any
  // further changes
  virtual void disconnectAuditors() {
    m_onChange.disconnectAll();
    m_beforeChange.disconnectAll();
  }

  // Assigns the value of another Property
  virtual Property<T>& operator=(Property<T> const& rhs) {
    set(rhs.m_value);
    return *this;
  }

  // Assigns a new value to this Property
  virtual Property<T>& operator=(T const& rhs) {
    set(rhs);
    return *this;
  }

  // Compares the values of two Properties
  bool operator==(Property<T> const& rhs) const {
    return Property<T>::get() == rhs.get();
  }
  bool operator!=(Property<T> const& rhs) const {
    return Property<T>::get() != rhs.get();
  }

  // Compares the values of the Property to another value
  bool operator==(T const& rhs) const { return Property<T>::get() == rhs; }
  bool operator!=(T const& rhs) const { return Property<T>::get() != rhs; }

  // Returns the value of this Property
  T const& operator()() const { return Property<T>::get(); }

 private:
  Signal<T>          m_onChange;
  Signal<T>          m_beforeChange;
  Property<T> const* m_connection   = nullptr;
  int                m_connectionID = -1;
  T                  m_value;
};

// Specialization for built-in default contructors
template <>
inline Property<double>::Property()
  : m_value(0.0) {}

template <>
inline Property<float>::Property()
  : m_value(0.f) {}

template <>
inline Property<short>::Property()
  : m_value(0) {}

template <>
inline Property<int>::Property()
  : m_value(0) {}

template <>
inline Property<char>::Property()
  : m_value(0) {}

template <>
inline Property<unsigned>::Property()
  : m_value(0) {}

template <>
inline Property<bool>::Property()
  : m_value(false) {}

} // namespace OpenPie

// Stream operators
template <typename T>
std::ostream& operator<<(std::ostream& out_stream, OpenPie::Property<T> const& val) {
  out_stream << val.get();
  return out_stream;
}

template <typename T>
std::istream& operator>>(std::istream& in_stream, OpenPie::Property<T>& val) {
  T tmp;
  in_stream >> tmp;
  val.set(tmp);
  return in_stream;
}

#endif // OPENPIE_PROPERTY_HPP
