/* appindicator-0.1.vapi generated by vapigen, do not modify. */

[CCode (cprefix = "App", lower_case_cprefix = "app_", gir_namespace = "AppIndicator", gir_version = "0.1")]
namespace AppIndicator {
	[CCode (cheader_filename = "libappindicator/app-indicator.h")]
	public class Indicator : GLib.Object {
		public AppIndicator.IndicatorPrivate priv;
		[CCode (has_construct_function = false)]
		public Indicator (string id, string icon_name, AppIndicator.IndicatorCategory category);
		public void build_menu_from_desktop (string desktop_file, string desktop_profile);
		public unowned string get_attention_icon ();
		public unowned string get_attention_icon_desc ();
		public AppIndicator.IndicatorCategory get_category ();
		public unowned string get_icon ();
		public unowned string get_icon_desc ();
		public unowned string get_icon_theme_path ();
		public unowned string get_id ();
		public unowned string get_label ();
		public unowned string get_label_guide ();
		public unowned Gtk.Menu get_menu ();
		public uint32 get_ordering_index ();
		public unowned Gtk.Widget get_secondary_activate_target ();
		public AppIndicator.IndicatorStatus get_status ();
		public void set_attention_icon (string icon_name);
		public void set_attention_icon_full (string icon_name, string icon_desc);
		public void set_icon (string icon_name);
		public void set_icon_full (string icon_name, string icon_desc);
		public void set_icon_theme_path (string icon_theme_path);
		public void set_label (string label, string guide);
		public void set_menu (Gtk.Menu? menu);
		public void set_ordering_index (uint32 ordering_index);
		public void set_secondary_activate_target (Gtk.Widget? menuitem);
		public void set_status (AppIndicator.IndicatorStatus status);
		[NoWrapper]
		public virtual void unfallback (Gtk.StatusIcon status_icon);
		[CCode (has_construct_function = false)]
		public Indicator.with_path (string id, string icon_name, AppIndicator.IndicatorCategory category, string icon_theme_path);
		public string attention_icon_desc { get; set; }
		[NoAccessorMethod]
		public string attention_icon_name { get; set; }
		public string category { get; construct; }
		[NoAccessorMethod]
		public bool connected { get; }
		public string icon_desc { get; set; }
		[NoAccessorMethod]
		public string icon_name { get; set; }
		public string icon_theme_path { get; set construct; }
		public string id { get; construct; }
		public string label { get; set; }
		public string label_guide { get; set; }
		public uint ordering_index { get; set; }
		public string status { get; set; }
		public virtual signal void connection_changed (bool indicator);
		public virtual signal void new_attention_icon ();
		public virtual signal void new_icon ();
		public virtual signal void new_icon_theme_path (string indicator);
		public virtual signal void new_label (string indicator, string label);
		public virtual signal void new_status (string indicator);
		public virtual signal void scroll_event (int indicator, uint delta);
	}
	[CCode (type_id = "APP_TYPE_INDICATOR_PRIVATE", cheader_filename = "libappindicator/app-indicator.h")]
	public struct IndicatorPrivate {
	}
	[CCode (cprefix = "APP_INDICATOR_CATEGORY_", cheader_filename = "libappindicator/app-indicator.h")]
	public enum IndicatorCategory {
		APPLICATION_STATUS,
		COMMUNICATIONS,
		SYSTEM_SERVICES,
		HARDWARE,
		OTHER
	}
	[CCode (cprefix = "APP_INDICATOR_STATUS_", cheader_filename = "libappindicator/app-indicator.h")]
	public enum IndicatorStatus {
		PASSIVE,
		ACTIVE,
		ATTENTION
	}
	[CCode (cheader_filename = "libappindicator/app-indicator.h")]
	public const string INDICATOR_SHORTY_NICK;
	[CCode (cheader_filename = "libappindicator/app-indicator.h")]
	public const string INDICATOR_SIGNAL_CONNECTION_CHANGED;
	[CCode (cheader_filename = "libappindicator/app-indicator.h")]
	public const string INDICATOR_SIGNAL_NEW_ATTENTION_ICON;
	[CCode (cheader_filename = "libappindicator/app-indicator.h")]
	public const string INDICATOR_SIGNAL_NEW_ICON;
	[CCode (cheader_filename = "libappindicator/app-indicator.h")]
	public const string INDICATOR_SIGNAL_NEW_ICON_THEME_PATH;
	[CCode (cheader_filename = "libappindicator/app-indicator.h")]
	public const string INDICATOR_SIGNAL_NEW_LABEL;
	[CCode (cheader_filename = "libappindicator/app-indicator.h")]
	public const string INDICATOR_SIGNAL_NEW_STATUS;
	[CCode (cheader_filename = "libappindicator/app-indicator.h")]
	public const string INDICATOR_SIGNAL_SCROLL_EVENT;
}
