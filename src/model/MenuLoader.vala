/* 
Copyright (c) 2011-2012 by Simon Schneegans

This program is free software: you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the Free
Software Foundation, either version 3 of the License, or (at your option)
any later version.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
more details.

You should have received a copy of the GNU General Public License along with
this program.  If not, see <http://www.gnu.org/licenses/>. 
*/

namespace OpenPie {

public class MenuLoader : GLib.Object {

    public MenuModel root { public get; private set; default = null; }
    
    construct {
        this.root = new MenuModel();
    }
    
    public MenuLoader.from_string(string data) {
        var parser = new Json.Parser();
        
        try {
            parser.load_from_data(data);
            load_from_json(this.root, new Json.Reader(parser.get_root()));
        } catch (GLib.Error e) {
            error(e.message);
        }
    }
    
    private void load_from_json(MenuModel current, Json.Reader reader) {
        foreach (var member in reader.list_members()) {
            reader.read_member(member);
        
            if (member == "subs") {
                if (reader.is_array()) {
                    for (int i=0; i<reader.count_elements(); ++i) {
                        reader.read_element(i);
                        var child = new MenuModel();
                        this.load_from_json(child, reader);
                        current.add_child(child);
                        reader.end_element();
                    }
                    
                } else {
                    warning("Element \"" + member + "\" in menu description has to be an array!");
                }
                
            } else if (member == "icon") {    
                current.icon = reader.get_string_value();
                
            } else if (member == "text") {  
                current.text = reader.get_string_value();
                
            } else if (member == "angle") {  
                current.angle = reader.get_double_value();

            } else {
                warning("Invalid element \"" + member + "\" in menu description!");
            }
            
            reader.end_member();
        }
    }
}

}
