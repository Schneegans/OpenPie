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
// An interface for menu plugins. It declares all necessary info fields       //
////////////////////////////////////////////////////////////////////////////////

public interface MenuPlugin : Menu {

  /////////////////////////// public variables /////////////////////////////////

  // name of the plugin, e.g. "Cool Menu"
  public abstract string name { get; construct set; }

  // version string, e.g. "2.0"
  public abstract string version { get; construct set; }

  // name of the main author, e.g. "John Doe"
  public abstract string author { get; construct set; }

  // email of the main author, e.g. "john.doe@sample.org"
  public abstract string email { get; construct set; }

  // homepage of the main author, e.g. "www.sample.org"
  public abstract string homepage { get; construct set; }

  // a description of the menu plugin, e.g. "A Cool Menu is a very cool menu
  //                                         because ... and ..."
  public abstract string description { get; construct set; }

  // this gets set by openpie and can be used to access resources
  public abstract string plugin_directory { get; set; }

}

}
