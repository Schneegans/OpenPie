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

public interface Plugin : Menu {
  public abstract string name        { get; construct set; }
  public abstract string version     { get; construct set; }
  public abstract string author      { get; construct set; }
  public abstract string email       { get; construct set; }
  public abstract string homepage    { get; construct set; }
  public abstract string description { get; construct set; }
}

}
