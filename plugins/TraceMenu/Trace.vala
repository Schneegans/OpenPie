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
// This class represents the trace performed by the user's finger. It         //
// calculates decision points where the user changed direction or paused the  //
// stroke.                                                                    //
////////////////////////////////////////////////////////////////////////////////

public class Trace : GLib.Object {

  //////////////////////////////////////////////////////////////////////////////
  //                         public interface                                 //
  //////////////////////////////////////////////////////////////////////////////

  /////////////////////////////// signals //////////////////////////////////////

  public signal void on_decision_point(Vector position);

  //////////////////////////// public methods //////////////////////////////////

  // ---------------------------------------------------------------------------
  construct {
    reset();
  }

  // ---------------------------------------------------------------------------
  public void reset() {
    stroke_ = {};
  }

  // ---------------------------------------------------------------------------
  public void update(Vector mouse) {

    if (stroke_.length == 0) {
      stroke_ += mouse;
      return;
    }

    var last_position = stroke_[stroke_.length-1];
    float dist = Vector.distance(mouse, last_position);

    if (dist > SAMPLING_DISTANCE) {
      var insert_samples = (int)(dist/SAMPLING_DISTANCE);
      var last = stroke_[stroke_.length-1];

      for (int i=1; i<=dist/SAMPLING_DISTANCE; ++i) {
        var t = (float)i/insert_samples;
        stroke_ += new Vector(
          t*mouse.x + (1-t)*last.x,
          t*mouse.y + (1-t)*last.y
        );
      }

      int length = stroke_.length;

      GLib.Timeout.add(PAUSE_DELAY, () => {

        // if nothing happened in between
        if (length == stroke_.length &&
            Vector.distance(stroke_[0], mouse) > TraceMenu.MINIMUM_DISTANCE) {

          on_decision_point(mouse);
          reset();
        }


        return false;
      });
    }

    if (stroke_.length >= 2) {
      float angle = Vector.angle(
        get_stroke_direction(),
        Vector.direction(stroke_[0], mouse)
      );

      if (angle > THRESHOLD_ANGLE &&
          Vector.distance(stroke_[0], mouse) > TraceMenu.MINIMUM_DISTANCE) {

        on_decision_point(last_position);
        reset();
        return;
      }
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  //                         private stuff                                    //
  //////////////////////////////////////////////////////////////////////////////

  ////////////////////////////// constants /////////////////////////////////////

  private const int    SAMPLING_DISTANCE = 10;
  private const uint   PAUSE_DELAY = 100;
  private const double THRESHOLD_ANGLE = GLib.Math.PI/30.0;

  ////////////////////////// member variables //////////////////////////////////

  private Vector[]  stroke_;

  ////////////////////////// private methods ///////////////////////////////////

  // ---------------------------------------------------------------------------
  private Vector get_stroke_direction() {
    Vector result = new Vector(0, 0);

    if (stroke_.length > 1) {
      for(int i=1; i<stroke_.length;++i) {
        result.x += stroke_[i].x / (stroke_.length-1);
        result.y += stroke_[i].y / (stroke_.length-1);
      }
    }

    return Vector.direction(stroke_[0], result);
  }

}

}
