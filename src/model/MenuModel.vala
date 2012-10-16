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

public class MenuModel {

    public string text = "Unnamed Item";
    public string icon = "none";
    public double angle = 0.0;

    public Gee.ArrayList<MenuModel> children;
    
    public MenuModel() {
        this.children = new Gee.ArrayList<MenuModel>();
    }
    
    public MenuModel.from_string(string data) {
        this.children = new Gee.ArrayList<MenuModel>();
        
        var parser = new Json.Parser();
        
        try {
            parser.load_from_data(data);
            load_from_json(new Json.Reader(parser.get_root()));
        } catch (GLib.Error e) {
            error(e.message);
        }
    }
    
    public void add_child(MenuModel item) {
        children.add(item);
    }
    
    public void beauty_print(int indent = 0) {
        string space = "";
        
        for (int i=0; i<indent; ++i)
            space += "  ";
            
        debug(space + text + " (" + icon + ")");
        
        foreach (var child in children)
            child.beauty_print(indent + 1);
    }
    
    private void load_from_json(Json.Reader reader) {
        foreach (var member in reader.list_members()) {
            reader.read_member(member);
        
            if (member == "subs") {
                if (reader.is_array()) {
                    for (int i=0; i<reader.count_elements(); ++i) {
                        reader.read_element(i);
                        var child = new MenuModel();
                        child.load_from_json(reader);
                        add_child(child);
                        reader.end_element();
                    }
                    
                } else {
                    warning("Element \"" + member + "\" in menu description has to be an array!");
                }
                
            } else if (member == "icon") {    
                icon = reader.get_string_value();
                
            } else if (member == "text") {  
                text = reader.get_string_value();
                
            } else if (member == "angle") {  
                angle = reader.get_double_value();
                
            } else {
                warning("Invalid element \"" + member + "\" in menu description!");
            }
            
            reader.end_member();
        }
    }
}

}
