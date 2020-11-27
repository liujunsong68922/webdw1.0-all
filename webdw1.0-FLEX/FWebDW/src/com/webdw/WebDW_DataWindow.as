package com.webdw
{
public class WebDW_DataWindow {
	public var unit :String ="";

	public var timer_interval :String ="";

	public var color :int =0;

	public var processiong :String ="";

	public var HTMLDW :String ="";

	public var print_documentname :String ="";

	public var print_orientation :int =0;

	public var print_margin_left :int =0;

	public var print_margin_right :int =0;

	public var print_margin_top :int =0;

	public var print_margin_bottom :int =0;

	public var print_paper_source :int =0;

	public var print_paper_size :int =0;

	public var print_prompt :String ="";

	public var print_buttons :String ="";

	public var print_preview_buttons :String ="";

	public var grid_lines :String ="";

	public function  Clone():WebDW_DataWindow {
		var newOne:WebDW_DataWindow = new WebDW_DataWindow();
		newOne.unit = this.unit;
		newOne.timer_interval = this.timer_interval;
		newOne.color = this.color;
		newOne.processiong = processiong;
		newOne.HTMLDW = HTMLDW;
		newOne.print_documentname = print_documentname;
		newOne.print_orientation = print_orientation;
		newOne.print_margin_left = print_margin_left;
		newOne.print_margin_right = print_margin_right;
		newOne.print_margin_top = print_margin_top;
		newOne.print_margin_bottom = print_margin_bottom;
		newOne.print_paper_source = print_paper_source;
		newOne.print_paper_size = print_paper_size;
		newOne.print_prompt = print_prompt;
		newOne.print_buttons = print_buttons;
		newOne.print_preview_buttons = print_preview_buttons;
		newOne.grid_lines = grid_lines;

		return newOne;
	}
}
}