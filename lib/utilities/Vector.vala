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
// A static class which stores all relevant paths used by OpenPie.            //
// These depend upon the location from which the program was launched.        //
////////////////////////////////////////////////////////////////////////////////

public class Vector : GLib.Object {
  
  //////////////////////////////////////////////////////////////////////////////
  //                          static interface                                //        
  //////////////////////////////////////////////////////////////////////////////
  
  // Creates a new vector between two points.
  public static Vector direction(Vector from, Vector to) {
    return new Vector(to.x - from.x, to.y - from.y);
  }
  
  // Adds two vectors.
  public static Vector sum(Vector a, Vector b) {
    return new Vector(a.x + b.x, a.y + b.y);
  }
  
  // Calculates the distance between two points.
  public static float distance(Vector from, Vector to) {
    return direction(from, to).length();
  }
  
  // Calculates the angle in radians between two vectors.
  public static float angle(Vector a, Vector b) {
    return GLib.Math.acosf(dot(a, b)/(a.length() * b.length()));
  }
  
  // Calculates the dot product of two vectors.
  public static float dot(Vector a, Vector b) {
    return a.x*b.x + a.y*b.y;
  }
  
  //////////////////////////////////////////////////////////////////////////////
  //                          public interface                                //        
  //////////////////////////////////////////////////////////////////////////////
  
  public float x {get; set; default=0;}
  public float y {get; set; default=0;}
  
  // Constructs a new vector.
  public Vector(float x = 0, float y = 0) {
    this.x = x;
    this.y = y;
  }
  
  // Returns the absolute length of the vector.
  public float length() {
    return GLib.Math.sqrtf(length_sqr());
  }
  
  // Returns the squared length. This method is faster than the above one --- so
  // please use this one for comparisons!
  public float length_sqr() {
    return x*x + y*y;
  }
  
  // Creates a new vector as a copy.
  public Vector copy() {
    return new Vector(x, y);
  }
  
  // Resizes the vector to unit length.
  public void normalize() {
    float length = length();
    
    if (length > 0) {
      x /= length;
      y /= length;
    }
  }
  
  // Sets the vector to have the desired length.
  public void set_length(float length) {
    float curr_length = this.length();
    
    if (curr_length > 0) {
      x /= curr_length/length;
      y /= curr_length/length;
    }
  }
  
  // Returns a string representation of the vector.
  public string to_string() {
    return "(%f, %f)".printf(x, y);
  }
}

}
