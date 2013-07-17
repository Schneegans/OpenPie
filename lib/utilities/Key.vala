////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2011-2013 by Simon Schneegans                                //
//                                                                            //
// This program is free software: you can redistribute it and/or modify it    //
// under the terms of the GNU General Public License as published by the Free //
// Software Foundation, either version 3 of the License, or (at your option)  //
// any later version.                                                         //
//                                                                            //
// This program is distributed in the hope that it will be useful, but        //
// WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY //
// or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License   //
// for more details.                                                          //
//                                                                            //
// You should have received a copy of the GNU General Public License along    //
// with this program.  If not, see <http://www.gnu.org/licenses/>.            //
////////////////////////////////////////////////////////////////////////////////

namespace OpenPie {

////////////////////////////////////////////////////////////////////////////////
// This class represents a hotkey, used to open menus. It supports any        //
// combination of modifier keys with keyboard and mouse buttons.              //
////////////////////////////////////////////////////////////////////////////////

public class Key : GLib.Object {

  //////////////////////////////////////////////////////////////////////////////
  //                          public interface                                //
  //////////////////////////////////////////////////////////////////////////////

  // Returns a human-readable version of this key.
  public string label { get; private set; default=""; }

  // The key string. Like [delayed]<Control>button3
  public string name { get; private set; default=""; }

  // The key code of the hotkey or the button number of the mouse.
  public int key_code { get; private set; default=0; }

  // The keysym of the hotkey or the button number of the mouse.
  public uint key_sym { get; private set; default=0; }

  // Modifier keys pressed for this hotkey.
  public Gdk.ModifierType modifiers { get; private set; default=0; }

  // True if this hotkey involves the mouse.
  public bool with_mouse { get; private set; default=false; }

  // C'tor, creates a new, "unbound" key.
  public Key() {
    this.set_unbound();
  }

  // C'tor, creates a new Key from a given key string. This is
  // in this format: "<modifier(s)>button" where
  // "<modifier>" is something like "<Alt>" or "<Control>", "button"
  // something like "s", "F4" or "button0".
  public Key.from_string(string key) {
    this.parse_string(key);
  }

  // C'tor, creates a new Key from a given key_sym and some associated
  // modifiers.
  public Key.from_keyboard(uint key_sym, Gdk.ModifierType modifiers) {
    string key = Gtk.accelerator_name(key_sym, modifiers);
    this.parse_string(key);
  }

  // C'tor, creates a new Key from a given mouse button and some associated
  // modifiers.
  public Key.from_mouse(uint button, Gdk.ModifierType modifiers) {
    string key = Gtk.accelerator_name(0, modifiers) + "button%u".printf(button);
    this.parse_string(key);
  }

  // Parses a key string. This is
  // in this format: "[option(s)]<modifier(s)>button" where
  // "<modifier>" is something like "<Alt>" or "<Control>", "button"
  // something like "s", "F4" or "button0" and "[option]" is either
  // "[turbo]", "[centered]" or "["delayed"]".
  public void parse_string(string key) {
    if (this.is_valid(key)) {
      // copy string
      string check_string = key;

      this.name = check_string;

      int button = this.get_mouse_button(check_string);
      if (button > 0) {
        this.with_mouse = true;
        this.key_code = button;
        this.key_sym = button;

        Gtk.accelerator_parse(check_string, null, out this._modifiers);
        this.label = Gtk.accelerator_get_label(0, this.modifiers);

        string button_text = _("Button %i").printf(this.key_code);

        if (this.key_code == 1)
          button_text = _("LeftButton");
        else if (this.key_code == 3)
          button_text = _("RightButton");
        else if (this.key_code == 2)
          button_text = _("MiddleButton");

        this.label += button_text;
      } else {
        this.with_mouse = false;

        var display = new X.Display();

        uint keysym = 0;
        Gtk.accelerator_parse(check_string, out keysym, out this._modifiers);
        this.key_code = display.keysym_to_keycode(keysym);
        this.key_sym = keysym;
        this.label = Gtk.accelerator_get_label(keysym, this.modifiers);
      }

    } else {
      this.set_unbound();
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  //                          private stuff                                   //
  //////////////////////////////////////////////////////////////////////////////

  // Resets all member variables to their defaults.
  private void set_unbound() {
    this.label = "Not bound";
    this.name = "";
    this.key_code = 0;
    this.key_sym = 0;
    this.modifiers = 0;
    this.with_mouse = false;
  }

  // Returns true, if the key string is in a valid format.
  private bool is_valid(string key) {
    // copy string
    string check_string = key;

    if (this.get_mouse_button(check_string) > 0) {
      // it seems to be a valid mouse-key so replace button part,
      // with something accepted by gtk, and check it with gtk
      int button_index = check_string.index_of("button");
      check_string = check_string.slice(0, button_index) + "a";
    }

    // now it shouls be a normal gtk accelerator
    uint keysym = 0;
    Gdk.ModifierType modifiers = 0;
    Gtk.accelerator_parse(check_string, out keysym, out modifiers);
    if (keysym == 0)
      return false;

    return true;
  }

  // Returns the mouse button number of the given key string.
  // Returns -1 if it is not a mouse key.
  private int get_mouse_button(string key) {
    if (key.contains("button")) {
      // it seems to be a mouse-key so check the button part.
      int button_index = key.index_of("button");
      int number = int.parse(key.slice(button_index + 6, key.length));
      if (number > 0)
        return number;
    }

    return -1;
  }
}

}

