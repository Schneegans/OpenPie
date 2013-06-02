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
// This class controls the appearance of an OpenPie menu. Styles can be       //
// loaded from file.                                                          //
////////////////////////////////////////////////////////////////////////////////

public class Style : GLib.Object {

  //////////////////////////////////////////////////////////////////////////////
  //              public interface                                            //        
  //////////////////////////////////////////////////////////////////////////////

  public Color background_color         { get; set; default = new Color.from_rgb(0.1f, 0.1f, 0.1f);}
  public Color background_color_hover   { get; set; default = new Color.from_rgb(0.8f, 0.8f, 0.8f);}
  public Color background_color_active  { get; set; default = new Color.from_rgb(1.0f, 1.0f, 1.0f);}
  
  public Color font_color               { get; set; default = new Color.from_rgb(0.8f, 0.8f, 0.8f);}
  public Color font_color_hover         { get; set; default = new Color.from_rgb(0.1f, 0.1f, 0.1f);}
  public Color font_color_active        { get; set; default = new Color.from_rgb(0.0f, 0.0f, 0.0f);}

  public static Style get_default()
  {
    return default_style_;
  }
  
  static construct 
  {
    default_style_ = new Style();
  }
  
  public Style() {

  }
  

  //////////////////////////////////////////////////////////////////////////////
  //              private stuff                                               //
  //////////////////////////////////////////////////////////////////////////////
  
  private static Style default_style_;
   
}   
  
}
