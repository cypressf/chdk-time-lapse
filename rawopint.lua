--[[
@title raw meter intervalometer
@chdk_version 1.4.1
#ui_shots=0 "Shots (0 = unlimited)"
#ui_interval_s10=20 "Interval Sec/10"
#ui_use_remote=false "USB remote interval control"
#ui_meter_width_pct=90 "Meter width %" [1 100]
#ui_meter_height_pct=90 "Meter height %" [1 100]
#ui_meter_step=15 "Meter step"
#ui_max_ev_change_e=3 "Max Ev change" {1/16 1/8 1/4 1/3 1/2 1}
#ui_ev_use_initial=false "Use initial Ev as target"
#ui_ev_shift_e=10 "Ev shift" {-2.1/2 -2.1/4 -2 -1.3/4  -1.1/2 -1.1/4 -1 -3/4 -1/2 -1/4 0 1/4 1/2 3/4 1 1.1/4 1.1/2 1.3/4 2 2.1/4 2.1/2}
#ui_bv_ev_shift_pct=0 "Bv Ev shift %" [0 100]
#ui_bv_ev_shift_base_e=0 "Bv Ev shift base Bv" {First -1 -1/2 0 1/2 1 1.1/2 2 2.1/2 3 3.1/2 4 4.1/2 5 5.1/2 6 6.1/2 7 7.1/2 8 8.1/2 9 9.1/2 10 10.1/2 11 11.1/2 12 12.1/2 13}
#ui_tv_max_s1k=1000 "Max Tv Sec/1000"
#ui_tv_min_s100k=10 "Min Tv Sec/100K" [1 99999]
#ui_sv_target_mkt=80 "Target ISO"
#ui_tv_sv_adj_s1k=250 "ISO adj Tv Sec/1000"
#ui_sv_max_mkt=800 "Max ISO"
#ui_tv_nd_thresh_s10k=1 "ND Tv Sec/10000"
#ui_nd_hysteresis_e=2 "ND hysteresis Ev" {none 1/4 1/2 3/4 1}
#ui_nd_value=288 "ND value APEX*96 (0=guess)" [0 1000]
#ui_nd_force_e=0 "Force initial ND (breaks Canon AE)" {No In Out}
#ui_meter_high_thresh_e=2 "Meter high thresh Ev" {1/2 3/4 1 1.1/4 1.1/2 1.3/4}
#ui_meter_high_limit_e=3 "Meter high limit Ev" {1 1.1/4 1.1/2 1.3/4 2 2.1/4}
#ui_meter_high_limit_weight=200 "Meter high max weight" [100 300]
#ui_meter_low_thresh_e=5 "Meter low thresh -Ev" {1/2 3/4 1 1.1/4 1.1/2 1.3/4 2 2.1/4 2.1/2 2.3/4 3 3.1/4 3.1/2 3.3/4 4 4.1/4 4.1/2 4.3/4 5}
#ui_meter_low_limit_e=7 "Meter low limit -Ev" {1 1.1/4 1.1/2 1.3/4 2 2.1/4 2.1/2 2.3/4 3 3.1/4 3.1/2 3.3/4 4 4.1/4 4.1/2 4.3/4 5 5.1/4 5.1/2 5.3/4 6}
#ui_meter_low_limit_weight=200 "Meter low max weight" [100 300]
#ui_exp_over_thresh_frac=3000 "Overexp thresh x/100k (0=Off)" [0 100000]
#ui_exp_over_margin_e=3 "Overexp Ev range" {1/32 1/16 1/8 1/4 1/3 1/2 2/3 3/4 1}
#ui_exp_over_weight_max=200 "Overexp max weight" [100 300]
#ui_exp_over_prio=0 "Overexp prio" [0 200]
#ui_exp_under_thresh_frac=10000 "Underexp thresh x/100k (0=Off)" [0 100000]
#ui_exp_under_margin_e=5 "Underexp -Ev" {7 6 5.1/2 5 4.1/2 4 3.1/2 3 2.1/2 2}
#ui_exp_under_weight_max=200 "Underexp max weight" [100 300]
#ui_exp_under_prio=0 "Underexp prio" [0 200]
#ui_histo_step_t=5 "Histogram step (pixels)" {5 7 9 11 15 19 23 27 31} table
#ui_image_size_e=0 "Image size" {Default L M1 M2 M3 S W}
#ui_use_raw_e=0 "Use raw" {Default Yes No}
#ui_use_cont=true "Use cont. mode if set"
#ui_display_mode_t=1 "Display" {On Off Blt_Off} table
#ui_shutdown_finish=false "Shutdown on finish"
#ui_shutdown_lowbat=true "Shutdown on low battery"
#ui_shutdown_lowspace=true "Shutdown on low space"
#ui_interval_warn_led=-1 "Interval warn LED (-1=off)"
#ui_interval_warn_beep=false "Interval warn beep"
#ui_do_draw=false "Draw debug info"
#ui_draw_meter_t=1 " Meter area" {None Corners Box} table
#ui_draw_gauge_y_pct=0 " Gauge Y offset %" [0 94]
#ui_log_mode=2 "Log mode" {None Append Replace} table
#ui_raw_hook_sleep=0 "Raw hook sleep ms (0=off)" [0 100]
#ui_noyield=false "Disable script yield"
#ui_sim=false "Run simulation"

License: GPL

Copyright 2014-2017 reyalp (at) gmail.com

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
with CHDK. If not, see <http://www.gnu.org/licenses/>.
]]

rawopint_version="0.23"

require'hookutil'
require'rawoplib'
props=require'propcase'

interval=ui_interval_s10*100

-- TODO not all available on all cams
-- 0 = large (native), 1 = M1, 2=M2, 3=M3, 4=S (640x480), 8=Wide. 5=Canon raw on some cams
image_size=({false,0,1,2,3,4,8})[ui_image_size_e + 1]
use_raw=({false,1,0})[ui_use_raw_e + 1]

-- quarter stops ... 0 24 48 ...
ui_ev_shift=(ui_ev_shift_e-10)*24
ui_meter_high_thresh =  (ui_meter_high_thresh_e + 2)*24
ui_meter_high_limit =  (ui_meter_high_limit_e + 4)*24
ui_meter_low_thresh =  -(ui_meter_low_thresh_e + 2)*24
ui_meter_low_limit =  -(ui_meter_low_limit_e + 4)*24
ui_nd_hysteresis=(ui_nd_hysteresis_e)*24

ui_nd_force=({false,'in','out'})[ui_nd_force_e + 1]
ui_max_ev_change = ({96/16,96/8,96/4,96/3,96/2,96})[(ui_max_ev_change_e + 1)]
ui_exp_over_margin_ev = ({96/32,96/16,96/8,96/4,96/3,96/2,2*96/3,3*96/4,96})[(ui_exp_over_margin_e + 1)]
ui_exp_under_margin_ev = ({96*7, 96*6, 96*5 + 48, 96*5, 96*4 + 48, 96*4, 96*3 + 48, 96*3, 96*2 + 48, 96*2})[ui_exp_under_margin_e+1]

ui_histo_step=tonumber(ui_histo_step_t.value)

-- half stops, first is auto
if ui_bv_ev_shift_base_e==0 then
	ui_bv_ev_shift_base_bv=false
else
	ui_bv_ev_shift_base_bv=(ui_bv_ev_shift_base_e - 3)*48
end

if ui_meter_high_thresh >= ui_meter_high_limit or
	ui_meter_low_thresh <= ui_meter_low_limit then
	error('meter limit must be > than thresh')
end

if ui_interval_warn_led < 0 then
	ui_interval_warn_led=false
end

-- log module
log={}
function log:init(opts)
	if not opts then
		error('missing opts');
	end
	self.cols={unpack(opts.cols)}
	self.vals={}
	self.funcs={}
	self.tables={}
	if opts.funcs then
		for n,f in pairs(opts.funcs) do
			if type(f) ~= 'function' then
				error('expected function')
			end
			self.funcs[n] = f
		end
	end
	self.name = opts.name
	self.dummy = opts.dummy
	if opts.buffer_mode then
		self.buffer_mode = opts.buffer_mode
	else
		self.buffer_mode = 'os'
	end
	if self.buffer_mode == 'table' then
		self.lines={}
	elseif self.buffer_mode ~= 'os' and self.buffer_mode ~= 'sync' then
		error('invalid buffer mode '..tostring(self.buffer_mode))
	end
	-- TODO may accept other options than sep later
	if opts.tables then
		for n,sep in pairs(opts.tables) do
			self.tables[n] = {sep=sep}
		end
	end
	self:reset_vals()
	-- checks after vals initialized
	for n, v in pairs(self.funcs) do
		if not self.vals[n] then
			error('missing func col '.. tostring(n))
		end
	end
	for n, v in pairs(self.tables) do
		if not self.vals[n] then
			error('missing table col '.. tostring(n))
		end
	end
	if self.dummy then
		local nop =function() return end
		self.write=nop
		self.write_data=nop
		self.flush=nop
		self.set=nop
	else
		-- TODO name should accept autonumber or date based options
		if not opts.append then
			os.remove(self.name)
		end
		if self.buffer_mode == 'os' then
			self.fh = io.open(self.name,'ab')
			if not self.fh then
				error('failed to open log')
			end
		end
		self:write_data(self.cols)
		self:flush()
	end
end
function log:prepare_write()
	if self.buffer_mode == 'os' then
		return
	end
	-- if self.buffer_mode == 'sync' or self.buffer_mode then
	self.fh = io.open(self.name,'ab')
	if not self.fh then
		error('failed to open log')
	end
end
function log:finish_write()
	if self.buffer_mode == 'os' then
		return
	end
	self.fh:close()
	self.fh=nil
end

function log:write_csv(data)
	-- TODO should handle CSV quoting
	self.fh:write(string.format("%s\n",table.concat(data,',')))
end
function log:write_data(data)
	if self.buffer_mode == 'table' then
		table.insert(self.lines,data)
		return
	end
	self:prepare_write()
	self:write_csv(data)
	self:finish_write()
end

function log:flush()
	if self.buffer_mode == 'os' then
		if self.fh then
			self.fh:flush()
		end
	elseif self.buffer_mode == 'table' then
		if #self.lines == 0 then
			return
		end
		self:prepare_write()
		for i,data in ipairs(self.lines) do
			self:write_csv(data)
		end
		self:finish_write()
		self.lines={}
	end
	-- 'sync' is flushed every line
end

function log:write()
	local data={}
	for i,name in ipairs(self.cols) do
		local v
		if self.funcs[name] then
			v=tostring(self.funcs[name]())
		elseif self.tables[name] then
			v=table.concat(self.vals[name],self.tables[name].sep)
		else
			v=self.vals[name]
		end
		table.insert(data,v)
	end
	self:write_data(data)
	self:reset_vals()
end
function log:reset_vals()
	for i,name in ipairs(self.cols) do
		if self.tables[name] then
			self.vals[name] = {}
		else
			self.vals[name] = ''
		end
	end
end
function log:set(vals)
	for name,v in pairs(vals) do
		if not self.vals[name] then
			error("unknown log col "..tostring(name))
		end
		if self.funcs[name] then
			error("tried to set func col "..tostring(name))
		end
		if self.tables[name] then
			table.insert(self.vals[name],v)
		else
			self.vals[name] = tostring(v)
		end
	end
end
--[[
return a function that records time offset from col named base_name
if name is not provided, function expects target aname as arg
]]
function log:dt_logger(base_name,name)
	if not self.vals[base_name] then
		error('invalid base field name')
	end
	if self.dummy then
		return function() end
	end
	if not name then
		return function(name)
			if not self.vals[name] then
				error('invalid col name')
			end
			self.vals[name]=get_tick_count() - self.vals[base_name]
		end
	end
	if not self.vals[name] then
		error('invalid col name')
	end
	return function()
		self.vals[name]=get_tick_count() - self.vals[base_name]
	end
end

--[[
return a printf-like function that appends to table col
]]
function log:text_logger(name)
	if not self.vals[name] then
		error('invalid col name')
	end
	if not self.tables[name] then
		error('text logger must be table field '..tostring(name))
	end
	if self.dummy then
		return function() end
	end
	return function(fmt,...)
		table.insert(self.vals[name],string.format(fmt,...))
	end
end

function log:close()
	if self.buffer_mode == 'table' then
		self:flush()
	end
	if self.fh then
		self.fh:close()
	end
end
-- end log module

-- display control module
disp={
	state=true,
	shutoff_time=false,
	mode=string.lower(ui_display_mode_t.value),
}

function disp:init(opts)
	if opts and opts.start_delay then
		self.shutoff_time = get_tick_count() + opts.start_delay
	end
	if self.mode == 'on' then
		self.control_fn=function() end
	elseif self.mode == 'blt_off' then
		self.control_fn=set_backlight
	else
		self.control_fn=set_lcd_display
	end
end

function disp:update()
	-- toggled on, not expired, do nothing (should have been turned on in toggle)
	if self.shutoff_time and get_tick_count() < self.shutoff_time then
		return
	end
	
	-- if on, and timeout expired turn off
	if self.state then
		self:enable(false)
		self.shutoff_time = false
		return
	end
	-- turn off every shot in backlight mode
	if self.mode == 'blt_off' then
		self:enable(false)
	end
end

function disp:enable(state)
	if self.mode == 'on' then
		return
	end
	self.state=state
	self.control_fn(state)
end

function disp:toggle(timeout)
	if not timeout then
		timeout = 30000
	end
	if self.state then
		logdesc('disp:toggle off')
		self.shutoff_time = false
		self:enable(false)
	else
		logdesc('disp:toggle on')
		self.shutoff_time = get_tick_count() + timeout
		self:enable(true)
	end
end
disp:init{
	-- show the first few shots
	start_delay = 15000,
}
-- end display module

-- shutdown handling module
shutdown={}
function shutdown:init(opts)
	self.reasons={}
	if not opts then
		opts={}
	end
	self.opts = opts -- note, reference not copy
	if not self.opts.lowbat_val then
		self.opts.lowbat_val = get_config_value(require'GEN/cnf_osd'.batt_volts_min)
	end
	if not self.opts.lowspace_kb_val then
		self.opts.lowspace_kb_val = 50*1024 -- 50 megs... could calc 1 raw + jpeg but not worth it
	end
end
function shutdown:check()
	if self.opts.lowbat and get_vbatt() < self.opts.lowbat_val then
		table.insert(self.reasons,'lowbat')
	end
	if self.opts.lowspace and get_free_disk_space() < self.opts.lowspace_kb_val then
		table.insert(self.reasons,'lowspace')
	end
	return #self.reasons > 0
end

function shutdown:reason()
	return table.concat(self.reasons,' ')
end

function shutdown:do_shutdown()
	post_levent_to_ui("PressPowerButton")
	-- probably not needed
	sleep(100)
	post_levent_to_ui("UnpressPowerButton")
end

function shutdown:finish()
	if #self.reasons == 0 and self.opts.finish then
		table.insert(self.reasons,'finish')
	end
	if #self.reasons > 0 then
		self:do_shutdown()
	end
end
-- end shutdown module

-- exposure module
exp={}

function exp:init(opts)
	local logvals={}
	for i,name in ipairs{
		'ev_change_max',
		'ev_shift',
		'ev_use_initial',
		'bv_ev_shift_pct',
		'bv_ev_shift_base_bv',
		'tv96_long_limit',
		'tv96_short_limit',
		'tv96_sv_thresh',
		'tv96_nd_thresh',
		'nd_value',
		'nd_force',
		'nd_hysteresis',
		'sv96_max',
		'sv96_target',
		'meter_width_pct',
		'meter_height_pct',
		'meter_step',
		'meter_high_thresh',
		'meter_high_limit',
		'meter_high_limit_weight',
		'meter_low_thresh',
		'meter_low_limit',
		'meter_low_limit_weight',
		'over_margin_ev',
		'over_thresh_frac',
		'under_margin_ev',
		'under_thresh_frac',
		'over_weight_max',
		'under_weight_max',
		'over_prio',
		'under_prio',
		'histo_step',
		'do_draw',
		'draw_meter',
		'draw_gauge_y_pct',
		'smooth',
	} do
		if opts[name] == nil then
			error('exp missing opt '..name)
		end
		self[name] = opts[name]
		table.insert(logvals,string.format("%s=%s",name,tostring(opts[name])))
	end

	-- TODO special value from usec_to_tv96
	if self.tv96_nd_thresh == -10000 then
		self.tv96_nd_thresh = false
	end

	self.meter_width =  (self.meter_width_pct * rawop.get_active_width()) / 100
	self.meter_height = (self.meter_height_pct * rawop.get_active_height()) / 100

	-- not strictly required, truncate to multiples of 4 to keep bayer alignment consistent
	self.meter_width = bitand(0xFFFFFFFC,self.meter_width)
	self.meter_height = bitand(0xFFFFFFFC,self.meter_height)
	
	-- meter rectangle, centered in active area
	self.meter_left = rawop.get_active_left() + rawop.get_active_width()/2 - self.meter_width/2
	self.meter_x_count = self.meter_width/self.meter_step
	self.meter_top = rawop.get_active_top() + rawop.get_active_height()/2 - self.meter_height/2
	self.meter_y_count = self.meter_height/self.meter_step

	-- weight of meter in "normal range" hard coded for now
	self.meter_base_weight = 100
	-- max weight inputs are in aboslute values, make relative to base weight
	self.meter_high_limit_weight = self.meter_high_limit_weight - self.meter_base_weight
	self.meter_low_limit_weight = self.meter_low_limit_weight - self.meter_base_weight

	self.over_thresh_weight=100
	self.over_frac_max = imath.sqrt(self.over_thresh_weight*imath.scale)
							*imath.sqrt(self.over_weight_max*imath.scale)/imath.scale^2

	self.under_thresh_weight=100
	self.under_frac_max = imath.sqrt(self.under_thresh_weight*imath.scale)
							*imath.sqrt(self.under_weight_max*imath.scale)/imath.scale^2

	-- log some calculated values
	for i,name in ipairs{
		'meter_top', 'meter_left',
		'meter_width','meter_height',
		'meter_x_count','meter_y_count',
	} do
		table.insert(logvals,string.format("%s=%s",name,tostring(self[name])))
	end
	
	-- scale for histo:range(), hard coded for now
	-- TODO NOTE histo_frac_to_pct format needs to be adjusted to match
	self.histo_scale = 1000000

	local histo_samples = (rawop.get_jpeg_width()/self.histo_step)*(rawop.get_jpeg_height()/self.histo_step)
	-- approx total number of pixels read by histo
	table.insert(logvals,string.format("histo_samples=%d",histo_samples))

	logdesc("init:%s",table.concat(logvals,' '))

	-- warn if < 10 pixels in histogram would trigger threshold
	if self.over_thresh_frac > 0 and 10*self.histo_scale/self.over_thresh_frac > histo_samples then
		logdesc('WARN:over_thresh histo_samples')
	end
	if self.under_thresh_frac > 0 and 10*self.histo_scale/self.under_thresh_frac > histo_samples then
		logdesc('WARN:under_thresh histo_samples')
	end

	-- TODO should just auto adjust and warn in log, or use multiple meters
	if self.meter_x_count*self.meter_y_count > bitshru(0xFFFFFFFF,rawop.get_bits_per_pixel()) then
		error("meter step too small")
	end
	if self.tv96_sv_thresh < self.tv96_long_limit then
		logdesc('WARN:tv96_sv_thresh < tv96_long_limit')
		self.tv96_sv_thresh = self.tv96_long_limit
-- TODO could disable instead
--		self.sv96_max = self.sv96_target
	end
	if self.sv96_max < self.sv96_target then
		logdesc('WARN:sv96_max < sv96_target')
		self.sv96_max = self.sv96_target
	end

	self.histo = rawop.create_histogram()
end

-- initialize values that might change between frames (blacklevel/neutral dependent)
function exp:init_frame()
	local bl=rawop.get_black_level()
	-- blacklevel initialized and unchanged
	if bl == self.black_level then
		return
	end
	self.black_level=bl
	-- white level shouldn't ever change, but more consistent to do it here
	self.white_level=rawop.get_white_level()
	-- histo limits in shot histo units
	-- lowest value to count as over exp, as shot histo value
	-- = raw(ev(whitelevel) - margin_ev)/(2^(bpp - histo_bpp))
	self.over_histo_min = bitshru(rawop.ev_to_raw(rawop.raw_to_ev(self.white_level)-self.over_margin_ev),rawop.get_bits_per_pixel() - 10)
	-- highest value to count as under exp, as shot histo value 
	-- = raw(-margin_ev)/(2^(bpp - histo_bpp))
	self.under_histo_max = bitshru(rawop.ev_to_raw(-self.under_margin_ev),rawop.get_bits_per_pixel() - 10)
	logdesc('init_frame:black_level=%d neutral=%d over_histo_min=%d under_histo_max=%d',
				self.black_level,
				rawop.get_raw_neutral(),
				self.over_histo_min,
				self.under_histo_max)
end


-- draw debug stuff on raw
function exp:draw_pct_bar(x, y, frac, max, width, dir, r, g, b)
	local w,h
	local len = (frac*width/max)
	if len < 0 then
		if dir == 'h' then
			x = x + len
		else
			y = y + len
		end
		len = -len
	end
	if dir == 'h' then
		w = len
		h = 8
	elseif dir == 'v' then
		h = len
		w = 8
	end
	if g then
		rawop.fill_rect_rgbg(x, y, w, h, r,g,b)
	else
		rawop.fill_rect(x, y, w, h, r)
	end
end

function exp:draw_ev_tick(left, top, tick_height, tick_width, width, bl_offset, max_ev, ev, r,g,b)
	if g then
		rawop.fill_rect_rgbg(left + (width*(bl_offset + ev))/max_ev,top,tick_width,tick_height,r,g,b)
	else
		rawop.fill_rect(left + (width*(bl_offset + ev))/max_ev,top,tick_width,tick_height,r)
	end
end

function exp:draw()
	local t0=get_tick_count()
	local drawval_high = self.white_level - self.black_level
	local drawval_low = self.black_level*2
	local drawval = drawval_high
	if self.mval > self.white_level - self.white_level/3 then
		drawval = drawval_low
	end
	local width = self.meter_x_count*self.meter_step
	local height = self.meter_y_count*self.meter_step

	-- box around meter area
	if self.draw_meter == 'box' then
		rawop.rect(self.meter_left,self.meter_top,width,height,2,drawval)
	elseif self.draw_meter == 'corners' then
		local len=64
		rawop.fill_rect(self.meter_left,self.meter_top,len,2,drawval)
		rawop.fill_rect(self.meter_left,self.meter_top+2,2,len-2,drawval)
		rawop.fill_rect(self.meter_left + width - len - 2,self.meter_top,len,2,drawval)
		rawop.fill_rect(self.meter_left + width - 2,self.meter_top+2,2,len-2,drawval)

		rawop.fill_rect(self.meter_left,self.meter_top+height - 2,len,2,drawval)
		rawop.fill_rect(self.meter_left,self.meter_top+height - len - 2,2,len-2,drawval)
		rawop.fill_rect(self.meter_left + width - len - 2,self.meter_top+height-2,len,2,drawval)
		rawop.fill_rect(self.meter_left + width - 2,self.meter_top+height-len-2,2,len-2,drawval)
	end
	
	-- debug display area
	local d_width = 800
	local d_top
	if self.draw_gauge_y_pct == 0 then
		d_top = rawop.get_jpeg_top() + 80 -- ensure min margin, < 1%
	else
	 	d_top = rawop.get_jpeg_top() + (self.draw_gauge_y_pct*rawop.get_jpeg_height())/100
	end
	local d_left = rawop.get_jpeg_left() + (rawop.get_jpeg_width() - d_width)/2
	-- meter level
	local bl_offset = -rawop.raw_to_ev(self.black_level+1)
	local max_ev = bl_offset + rawop.raw_to_ev(self.white_level)

	-- get appropriate drawval with a tiny meter
	local mv = rawop.meter(d_left + d_width/2 - 64,d_top,18,9, 7,7)
	if mv > self.white_level - self.white_level/3 then
		drawval = drawval_low
	else
		drawval = drawval_high
	end

	self:draw_pct_bar(d_left,
					d_top,
					bl_offset + self.mval96,
					max_ev,
					d_width,
					'h',
					drawval)
	-- meter ticks
	-- black level
	rawop.fill_rect(d_left,d_top-8,4,30,drawval)
	-- white level
	rawop.fill_rect(d_left+d_width-2,d_top-8,4,30,drawval)
	-- neutral (0 ev)
	self:draw_ev_tick(d_left,d_top-8,8,4,d_width,bl_offset,max_ev,0,drawval)
	self:draw_ev_tick(d_left,d_top+8,14,4,d_width,bl_offset,max_ev,0,drawval)
	-- draw generic stops before and after neutral
	local i = -96
	repeat
		self:draw_ev_tick(d_left,d_top+8,10,4,d_width,bl_offset,max_ev,i,drawval)
		i = i - 96
	until bl_offset + i <= 0

	i = 96
	repeat
		self:draw_ev_tick(d_left,d_top+8,10,4,d_width,bl_offset,max_ev,i,drawval)
		i = i + 96
	until i >= max_ev - bl_offset
	-- draw meter limits, thresh = yellow, limit = red
	self:draw_ev_tick(d_left,d_top-12,8,4,d_width,bl_offset,max_ev,self.ev_target_base + self.meter_low_thresh,drawval_high,drawval_high,drawval_low)
	self:draw_ev_tick(d_left,d_top-12,8,4,d_width,bl_offset,max_ev,self.ev_target_base + self.meter_low_limit,drawval_high,drawval_low,drawval_low)
	self:draw_ev_tick(d_left,d_top-12,8,4,d_width,bl_offset,max_ev,self.ev_target_base + self.meter_high_thresh,drawval_high,drawval_high,drawval_low)
	self:draw_ev_tick(d_left,d_top-12,8,4,d_width,bl_offset,max_ev,self.ev_target_base + self.meter_high_limit,drawval_high,drawval_low,drawval_low)
	
	-- if ev shift is in effect, draw tick on top of everything else
	if self.ev_target ~= 0 then
		self:draw_ev_tick(d_left,d_top-8,8,4,d_width,bl_offset,max_ev,self.ev_target,drawval_low,drawval_high,drawval_low)
		self:draw_ev_tick(d_left,d_top+8,14,4,d_width,bl_offset,max_ev,self.ev_target,drawval_low,drawval_high,drawval_low)
	end

	-- exposure change
	self:draw_pct_bar(d_left + d_width/2,
						d_top + 30,
						self.ev_change,
						self.ev_change_max,
						d_width/2,
						'h',
						drawval)
	-- ticks for left, mid, right
	rawop.fill_rect(d_left,d_top+38,4,16,drawval)
	rawop.fill_rect(d_left+d_width/2-2,d_top+38,4,16,drawval)
	rawop.fill_rect(d_left+d_width-4,d_top+38,4,16,drawval)

	-- TODO under/over fracs are absolute, relative to threshold would be useful
	-- under exposed fraction
	local r,g,b = drawval,drawval,drawval
	if self.under_frac >= self.under_thresh_frac then
		r = drawval_high
		g,b = drawval_low,drawval_low
	end
	-- left to right
	self:draw_pct_bar(d_left,d_top+54, self.under_frac, self.histo_scale, d_width/2, 'h', r, g, b)

	-- over exposured fraction
	if self.over_frac >= self.over_thresh_frac then
		r = drawval_high
		g,b = drawval_low,drawval_low
	else
		r,g,b = drawval,drawval,drawval
	end
	-- right to left
	self:draw_pct_bar(d_left + d_width, d_top+54, -self.over_frac, self.histo_scale, d_width/2, 'h', r, g, b)

	log:set{draw_time=get_tick_count()-t0}
end

function exp:clamp(v,min,max)
	-- single value, assume +/-
	if not max then
		max = min
		min = -max
	end
	if v > max then
		return max
	elseif v < min then
		return min
	end
	return v
end

function exp:calc_ev_change()
	local last_ev_change
	
	-- handle first iteration
	-- TODO ugly
	if self.ev_change then
		last_ev_change = self.ev_change
	else
		if self.bv_ev_shift_base_bv then
			self.bv96_init = self.bv_ev_shift_base_bv
		else
			self.bv96_init = self.bv96
		end
		-- first time through
		last_ev_change = 0
		self.ev_target_base = self.ev_shift
		-- if using initial as target, add to ev_shift
		if self.ev_use_initial then
			logdesc('initial ev:%d+%d',self.mval96,self.ev_shift)
			self.ev_target_base = self.ev_target_base + self.mval96
		end
	end

	-- adjust limits that are relative to ev shift, without modifying initial values
	local meter_high_thresh	= self.ev_target_base + self.meter_high_thresh
	local meter_high_limit	= self.ev_target_base + self.meter_high_limit
	local meter_low_thresh	= self.ev_target_base + self.meter_low_thresh
	local meter_low_limit	= self.ev_target_base + self.meter_low_limit

	-- bv change from initial
	local bv_change = self.bv96 - self.bv96_init
	-- shift by % of over or under initial value
	local bv_ev_shift = (bv_change*self.bv_ev_shift_pct)/100

	-- limit shift by meter limits
	-- simple linear ramp
	if bv_ev_shift > meter_high_thresh then
		local over = bv_ev_shift - meter_high_thresh
		if over > 2*(meter_high_limit - meter_high_thresh) then
			logdesc('bv ev limit:%d',bv_ev_shift)
			bv_ev_shift = meter_high_limit
		else
			logdesc('bv ev thresh:%d',bv_ev_shift)
			bv_ev_shift = meter_high_thresh + over/2
		end
	elseif bv_ev_shift < meter_low_thresh then
		local under = bv_ev_shift - meter_low_thresh
		if under < 2*(meter_low_limit - meter_low_thresh) then
			logdesc('bv ev -limit:%d',bv_ev_shift)
			bv_ev_shift = meter_low_limit
		else
			logdesc('bv ev -thresh:%d',bv_ev_shift)
			bv_ev_shift = meter_low_thresh + under/2
		end

	end
	
	log:set{bv_ev_shift=bv_ev_shift}

	-- adjust target for this shot
	self.ev_target = self.ev_target_base + bv_ev_shift

	-- basic change: difference of last exposure from metered exposure
	-- plus exposure shift
	local ev_change = self.ev_target - self.mval96

	ev_change = self:clamp(ev_change,self.ev_change_max)

	-- basic weight
	local meter_weight = self.meter_base_weight

	-- if over / under exposed beyond thresholds, increase meter weight
	-- high limit - driven above "ideal" value by underexp
	if self.mval96 > meter_high_thresh then
		local range = meter_high_limit - meter_high_thresh
		-- amount of range we have left
		local frac = meter_high_limit - self.mval96
		-- if above limit, clamp to limit
		if frac <= 0 then
			meter_weight = meter_weight + self.meter_high_limit_weight
		else
			-- otherwise, weight bonus = (max_bonus - margin_remaining)^2/max_bonus
			meter_weight = meter_weight + (self.meter_high_limit_weight - (self.meter_high_limit_weight*frac)/range)^2/self.meter_high_limit_weight
		end
	-- low limit - driven below "ideal" value by overexp
	-- TODO will also be hit if max shutter / iso reached
	elseif self.mval96 < meter_low_thresh then
		local range = meter_low_thresh - meter_low_limit
		local frac = self.mval96 - meter_low_limit
		if frac <= 0 then
			meter_weight = meter_weight + self.meter_low_limit_weight
		else
			meter_weight = meter_weight + (self.meter_low_limit_weight - (self.meter_low_limit_weight*frac)/range)^2/self.meter_low_limit_weight
		end
	end

	-- TODO
	-- to avoid flapping as limits approached over / under weights
	-- are calculated as (% of threshold)^2/(100)
	-- clamped to maximum weight
	-- this makes under / over start to have a slight effect as soon as there is any over/under
	-- and ramp up quickly as it exceeds the threshold
	local over_weight = 0
	local over_fw
	if self.over_thresh_frac > 0 then
		if self.over_frac > 0 then
			-- fraction threshold used by measured over exposure
			over_fw = self.over_frac*self.over_thresh_weight/self.over_thresh_frac
			-- if over by enough to hit weight limit, use max val
			if over_fw > self.over_frac_max then
				over_weight = self.over_weight_max
			else
				over_weight = over_fw^2/self.over_thresh_weight
			end
		end
	end

	local under_weight = 0
	local under_fw
	if self.under_thresh_frac > 0 then
		if self.under_frac > 0 then
			-- fraction threshold used by measured under exposure
			under_fw = (self.under_frac*self.under_thresh_weight)/self.under_thresh_frac
			-- if over by enough to hit weight limit, use max val
			if under_fw > self.under_frac_max then
				under_weight = self.under_weight_max
			else
				under_weight = under_fw^2/self.under_thresh_weight
			end
		end
	end

	-- priority adjustments
	if over_fw and self.over_prio > 0 then
		local prio_mod = self:clamp(over_fw * self.over_prio / self.over_thresh_weight,0,self.over_prio)
		-- meter in opposite direction?
		if ev_change > 0 then
			logdesc("over prio meter %d-%d",meter_weight,prio_mod)
			meter_weight = meter_weight - prio_mod
			if meter_weight < 0 then
				meter_weight = 0
			end
		end
		-- under exposure
		if under_fw then
			logdesc("over prio under %d-%d",under_weight,prio_mod)
			under_weight = under_weight - prio_mod
			if under_weight < 0 then
				under_weight = 0
			end
		end
	end

	if under_fw and self.under_prio > 0 then
		local prio_mod = self:clamp(under_fw * self.under_prio / self.under_thresh_weight,0,self.under_prio)
		-- meter in opposite direction?
		if ev_change < 0 then
			logdesc("under prio meter %d-%d",meter_weight,prio_mod)
			meter_weight = meter_weight - prio_mod
			if meter_weight < 0 then
				meter_weight = 0
			end
		end
		-- over exposure
		if over_fw then
			logdesc("under prio over %d-%d",over_weight,prio_mod)
			over_weight = over_weight - prio_mod
			if over_weight < 0 then
				over_weight = 0
			end
		end
	end

	log:set{
		meter_weight=meter_weight,
		over_weight=over_weight,
		under_weight=under_weight,
	}
	ev_change = (ev_change*meter_weight - self.ev_change_max*over_weight + self.ev_change_max*under_weight)/(meter_weight + over_weight + under_weight)

	-- clamp to ui max
	-- TODO everything above should already be in limits
	ev_change = self:clamp(ev_change,self.ev_change_max)

	-- smooth out rapid changes
	-- TODO smoothed fraction should be configurable
	if self.smooth then
		local ev_change_smooth = ev_change + last_ev_change
		ev_change_smooth = ev_change_smooth/2 + ev_change_smooth%2
		-- but don't allow overshoot in the wrong direction
		if (ev_change == 0 and ev_change_smooth ~= 0) 
			or (ev_change_smooth > 0 and ev_change < 0) 
			or (ev_change_smooth < 0 and ev_change > 0) then
			logdesc('smooth overshoot:%d',ev_change_smooth)
			ev_change = 0
		else
			ev_change = ev_change_smooth
		end
		-- TODO hacky hardcoded
		-- sign changed, reduce by half (and trunc to 0 if 1)
		if ev_change * last_ev_change < 0 then
			logdesc('smooth sign switch')
			ev_change = ev_change/2
		end
	end

	self.ev_change = ev_change

	log:set{
		d_ev=self.ev_change,
	}
end

-- read meter values from frame buffer
function exp:do_meter()
	local t0=get_tick_count()
	self.mval = rawop.meter(self.meter_left,self.meter_top,
								self.meter_x_count,self.meter_y_count,
								self.meter_step,self.meter_step)

	log:set{meter_time=get_tick_count()-t0}

	self.mval96 = rawop.raw_to_ev(self.mval)

	t0=get_tick_count()
	-- parameters similar to shot_histogram
	-- use jpeg area to avoid dark borders
	self.histo:update(rawop.get_jpeg_left(),rawop.get_jpeg_top(),
						rawop.get_jpeg_width(),
						rawop.get_jpeg_height(),
						self.histo_step,self.histo_step,10)
	-- shot histo values always scaled to 10 bit, assume white=1023, black=31
	-- ignore much lower than black, typically bad pixels
	self.over_frac = self.histo:range(self.over_histo_min,1023,self.histo_scale)
	self.under_frac = self.histo:range(4,self.under_histo_max,self.histo_scale)
	log:set{histo_time=get_tick_count()-t0}
end
function exp:histo_frac_to_pct(v)
	return string.format("%d.%04d",v/(self.histo_scale/100),v%(self.histo_scale/100))
end
function exp:log_meter()
	-- log meter values
	log:set{
		meter=self.mval,
		meter96=self.mval96,
		over_frac=self:histo_frac_to_pct(self.over_frac),
		under_frac=self:histo_frac_to_pct(self.under_frac),
	}
end

function exp:nd96_for_state(nd_state)
	-- only used for cams with iris
	if get_nd_present() == 2 and nd_state then
		return self.nd_value
	end
	return 0
end
function exp:init_exposure_params_from_cam()
	self.tv96 = get_prop(props.TV)
	self.sv96 = get_prop(props.SV)
	self.av96 = get_prop(props.AV)
	self.bv96 = get_prop(props.BV)

	if get_nd_present() == 1 then
		local min_av = get_prop(props.MIN_AV)
		if self.av96 > min_av then
			if self.nd_value == 0 then
				self.nd_value = self.av96 - min_av
				logdesc('nd_value from av=%d',self.nd_value)
			end
			self.nd_state = true
		else
			if self.nd_value == 0 then
				self.nd_value = 3*96 -- TODO don't really know, reported value varies slightly between cams
				logdesc('nd_value default=%d',self.nd_value)
			end
			self.nd_state = false
		end
	elseif get_nd_present() == 2 then
		if self.nd_value == 0 then
			-- TODO manual non-hidden ND cams have propcases that gives value, but not in propset files
			self.nd_value = 3*96 -- TODO don't really know, reported value varies slightly between cams
			logdesc('nd_value default=%d',self.nd_value)
		end
		if props.ND_FILTER_STATE then
			if self.nd_force == 'in' then
				self.nd_state = true
			elseif self.nd_force == 'out' then
				self.nd_state = false
			else
				-- TODO this won't work with 'hidden' ND
				if get_prop(props.ND_FILTER_STATE) == 1 then
					self.nd_state = true
				else
					self.nd_state = false
				end
			end
		end
	end
	self.nd96 = self:nd96_for_state(self.nd_state)
end

-- initialization before first half press
function exp:init_before_preshoot()
	if get_nd_present() > 0 then
		if self.nd_force == 'out' then
			set_nd_filter(2)
		elseif self.nd_force == 'in' then
			set_nd_filter(1)
		end
		-- only intended for hidden ND cams
		if get_nd_present() == 1 then
			logdesc('WARN:nd_force on ND-only cam')
		end
	else
		logdesc('WARN:nd_force ignored on no-ND cam')
	end
end

-- initialization after initial halfpress ready
function exp:init_preshoot()
	self:init_exposure_params_from_cam()
	self:log_exposure_params()
	log:set{bv96=self.bv96}
	-- TODO could try to use Bv and ev comp setting
	self.ev_change = 0 

	-- turn EV change into updated exposure settings
	self:calc_exposure_params()
	
	-- set values for next exposure
	self:set_cam_exposure_params()
	-- TODO force initialization on first real shot
	self.ev_change = nil
end

--[[
check if cam used values match set values, can fail if ISO_BASE is wrong
]]
function exp:sanity_check_cam_exposure_params()
	local cam_tv96 = get_prop(props.TV)
	local cam_sv96 = get_prop(props.SV)
	local cam_av96 = get_prop(props.AV)
	if self.tv96 ~= cam_tv96 then
		logdesc('tv %s != cam %s',tostring(self.tv96),tostring(cam_tv96))
	end
	if self.sv96 ~= cam_sv96 then
		logdesc('sv %s != cam %s',tostring(self.sv96),tostring(cam_sv96))
	end
	if self.av96 ~= cam_av96 then
		logdesc('av %s != cam %s',tostring(self.av96),tostring(cam_av96))
	end
end

function exp:set_cam_exposure_params()
	set_tv96_direct(self.tv96)
	set_sv96(self.sv96)
	-- ND only
	if get_nd_present() == 1 then
		if self.nd_state then
			set_nd_filter(1)
			set_prop(props.AV,get_prop(props.MIN_AV)+self.nd_value)
		else
			set_nd_filter(2)
			set_prop(props.AV,get_prop(props.MIN_AV))
		end
	elseif get_nd_present() == 2 then
		-- ND + iris
		if self.nd_state then
			set_nd_filter(1)
		else
			set_nd_filter(2)
		end
	end
end

-- update exposure params from cam if needed, log
function exp:get_cam_exposure_params()
	-- on the first shot, get exposure values from cam
	if not self.tv96 then
		self:init_exposure_params_from_cam()
	else
	-- otherwise, compare cam values to last set values and log if different
		self:sanity_check_cam_exposure_params()
	end
end

function exp:log_exposure_params()
	-- log exposure values for shot we just metered
	local tvus=tv96_to_usec(self.tv96)
	local av1k=av96_to_aperture(self.av96)
	local nd
	if self.nd_state then
		nd=1
	else
		nd=0
	end
	log:set{
		sv=sv96_to_iso(sv96_real_to_market(self.sv96)),
		sv96=self.sv96,
		av=string.format("%d.%03d",av1k/1000,((av1k%1000))),
		av96=self.av96,
		tv=string.format("%d.%06d",tvus/1000000,((tvus%1000000))),
		tv96=self.tv96,
		nd=nd,
	}
end

-- calculate new exposure settings from EV change
function exp:calc_exposure_params()
	-- start with ev change on Tv
	local tv96_new = self.tv96 - self.ev_change

	local sv_extra = 0

	local sv96_new = self.sv96_target

	-- TODO initial may be over limits
	if self.sv96 > self.sv96_max then
		logdesc('sv prev > sv max')
	end
	if self.sv96 > sv96_new then
		sv_extra = self.sv96 - sv96_new
	end

	-- put anything over base ISO on Tv, will add back later if tv limits hit
	tv96_new = tv96_new - sv_extra

	local nd_state_new
	local av96_new = self.av96
	-- TODO doesn't handle cases where sv thresh overlaps with ND range
	if get_nd_present() > 0 then
		local nd_state_old = self.nd_state
		if self.nd_state then
			-- if ND was in for last shot, add value back to tv and clear
			tv96_new = tv96_new + self.nd_value
			-- if ND only, remove from av
			if get_nd_present() == 1 then
				av96_new = av96_new - self.nd_value
			end
			nd_state_new = false
		end
		if self.tv96_nd_thresh and tv96_new > self.tv96_nd_thresh then
			logdesc('tv over nd:%d',tv96_new - self.tv96_nd_thresh)
			nd_state_new = true
		elseif self.tv96_nd_thresh and nd_state_old and tv96_new > self.tv96_nd_thresh - self.nd_hysteresis then
			logdesc('tv nd hyst:%d',tv96_new - self.tv96_nd_thresh)
			nd_state_new = true
		end
		if nd_state_new then
			tv96_new = tv96_new - self.nd_value
			if get_nd_present() == 1 then
				av96_new = av96_new + self.nd_value
			end
		end
	end

	local tv_extra = 0

	-- only do ISO adjustment + messages if range defined
	if self.sv96_target < self.sv96_max then 
		if tv96_new < self.tv96_sv_thresh then
			local over = self.tv96_sv_thresh - tv96_new
			if over > (self.tv96_sv_thresh - self.tv96_long_limit)*2 then
				tv_extra = tv96_new - self.tv96_long_limit
				tv96_new = self.tv96_long_limit
				logdesc('tv over long:%d',-tv_extra)
			else
				tv_extra = -over/2
				tv96_new = tv96_new - tv_extra
				logdesc('tv iso adj:%d',-tv_extra)
			end
		end

		if tv_extra < 0 then
			sv96_new = sv96_new - tv_extra
		end
		if sv96_new > self.sv96_max then
			local sv_over = sv96_new - self.sv96_max
			logdesc('iso over limit:%d',sv_over)
			-- if ISO range isn't past end of shutter range, put remainder back on shutter
			if tv96_new > self.tv96_long_limit then
				logdesc('iso over tv:%d',tv96_new - self.tv96_long_limit)
				tv96_new = tv96_new - sv_over
				if tv96_new < self.tv96_long_limit then
					tv96_new = self.tv96_long_limit
				end
			end

			sv96_new = self.sv96_max
		end
	else
		if tv96_new < self.tv96_long_limit then
			logdesc('tv over long:%d',self.tv96_long_limit- tv96_new)
			tv96_new = self.tv96_long_limit
		end
	end

	if tv96_new > self.tv96_short_limit then
		logdesc('tv under short:%d',tv96_new)
		tv96_new = self.tv96_short_limit
	end


	self.tv96 = tv96_new
	self.sv96 = sv96_new
	self.av96 = av96_new
	self.nd_state = nd_state_new
	self.nd96 = self:nd96_for_state(self.nd_state)
end

--[[
force reset of values that are calculated from first exposure
]]
function exp:reset()
	-- force reset of last ev, shifted values
	self.ev_change=nil
	-- force refresh of exposure values from cam exposure
	self.tv96 = nil
end


-- meter and update exposure
function exp:run()
	-- initialize raw buffer related values that can change between frames
	self:init_frame()
	-- update / sanity check settings from previous exposure
	self:get_cam_exposure_params()
	-- log previous exposure
	self:log_exposure_params()

	self:do_meter()
	self:log_meter()

	if self.mval == 0 then
		log:set{meter='fail'}
		return
	end

	-- if m96 == 0, bv = tv + av - sv
	-- nd96 is works like av, for cameras with both iris and ND
	self.bv96 = self.tv96 + self.av96 + self.nd96 - self.sv96 + self.mval96

	log:set{bv96=self.bv96}

	-- calculate required EV change
	self:calc_ev_change()

	-- turn EV change into updated exposure settings
	self:calc_exposure_params()
	
	-- set values for next exposure
	self:set_cam_exposure_params()
	
	if self.do_draw then
		self:draw()
	end
end
-- end exposure module

-- exp simulation module
function exp:simulate_init_exposure_params_from_cam()
	self.tv96 =	self.sim.init_TV 
	self.sv96 =	self.sim.init_SV 
	self.av96 =	self.sim.init_AV 
end

function exp:simulate_do_meter()
	self.sim.frame = self.sim.frame + 1
	local frame = self.sim.data[self.sim.frame]
	local delta_tv = self.tv96 - self.sim.init_TV
	local delta_sv = self.sv96 - self.sim.init_SV 
	-- TODO include AV
	local m = self.sim.init_bv + frame.delta_bv + delta_sv - delta_tv

	if m > rawop.raw_to_ev(self.white_level) then
		m = rawop.raw_to_ev(self.white_level)
	elseif m < rawop.raw_to_ev(self.black_level) then
		m = rawop.raw_to_ev(self.black_level)
	end

	self.mval = rawop.ev_to_raw(m) 
	self.mval96 = m -- extra conversion loses precision -- rawop.raw_to_ev(self.mval)
	
	-- we can't actually know over/under will respond, fake it

	-- difference between current meter and original
	local delta_m = m - frame.mval96

	-- if over threshold calculated in init, add to over_frac
	if delta_m > frame.over_dev then
		self.over_frac = (delta_m-frame.over_dev)/self.sim.over_ev_factor
	else
		self.over_frac = 0
	end
	if delta_m < frame.under_dev then
		self.under_frac = (frame.under_dev-delta_m)/self.sim.under_ev_factor
	else
		self.under_frac = 0
	end
	-- TODO logging to unused columns
	log:set{raw_ready=frame.delta_bv,meter_time=delta_m,draw_time=frame.over_dev,raw_done=frame.under_dev}
end


-- note index is zero based
function exp:extract_csv_col(line,index)
	local i=0
	local s=0
	while i < index and s do
		i = i + 1
		s=string.find(line,',',s+1,true)
		if not s then
			return
		end
	end
	return string.match(line,'([^,]*)',s+1)
end

function exp:sim_load_csv(filename)
	local fh=io.open(filename,'rb')
	if not fh then
		error('failed to open '..tostring(filename))
	end
	-- get column indexes from header
	local line=fh:read()
	local i=0
	local cols={}
	while true do
		local col_name = self:extract_csv_col(line,i)
		if not col_name then
			break
		end
		cols[col_name]=i
		i=i+1
	end
	local col_names={'av96','sv96','tv96','meter96','over_frac','under_frac'}

	local data={}
	local i=1
	for line in fh:lines() do
		data[i]={}
		for j,name in pairs(col_names) do
			data[i][name] = tonumber(self:extract_csv_col(line,cols[name]))
		end
		i=i+1
	end
	fh:close()
	collectgarbage('collect')
	return data
end

function exp:sim_init()
	self.sim = {
		data={},
		frame=0,
	}
	local data=self:sim_load_csv('A/rawopsim.csv')
	print('loaded',#data,'rows')
	self.sim.init_TV = data[1].tv96
	self.sim.init_SV = data[1].sv96
	self.sim.init_AV = data[1].av96
	self.sim.init_bv = data[1].meter96

	-- abitrary - assume every 1/1000 over/under exposure is 1 ev96 units
	self.sim.over_ev_factor = 1
	self.sim.under_ev_factor = 1

	for i,v in ipairs(data) do
		self.sim.data[i] = {
			over_frac = v.over_frac,
			under_frac = v.under_frac,
			delta_bv = v.tv96 - self.sim.init_TV + self.sim.init_SV - v.sv96 + v.meter96 - self.sim.init_bv,
			mval96 = v.meter96,
		}
		if v.over_frac > 0 then
			self.sim.data[i].over_dev = - (v.over_frac)*self.sim.over_ev_factor
		end
		if v.under_frac > 0 then
			self.sim.data[i].under_dev = (v.under_frac)*self.sim.under_ev_factor
		end
		-- keep garbage down
		data[i]=nil
		collectgarbage('step')
	end
	data = nil
	collectgarbage('collect')

	-- start out assuming two stops required for over, 3 for under
	if not self.sim.data[1].over_dev then
		self.sim.data[1].over_dev = 2*96
	end
	if not self.sim.data[1].under_dev then
		self.sim.data[1].under_dev = -3*96
	end
	local function lerp(v1,v2,pos,dist)
		return (v1*(dist - pos) + pos*(v2 - v1))/dist
	end

	local over_last_i = 1
	local under_last_i = 1
	for i,v in ipairs(self.sim.data) do
		if v.over_dev then
			for j=over_last_i+1,i-1 do
				self.sim.data[j].over_dev = lerp(self.sim.data[over_last_i].over_dev,v.over_dev,j-over_last_i,i-over_last_i)
			end
			over_last_i = i
		end
		if v.under_dev then
			for j=under_last_i+1,i-1 do
				self.sim.data[j].under_dev = lerp(self.sim.data[under_last_i].under_dev,v.under_dev,j-under_last_i,i-under_last_i)
			end
			under_last_i = i
		end
	end
	-- fill with last known value
	for j=over_last_i+1,#self.sim.data do
		self.sim.data[j].over_dev = self.sim.data[over_last_i].over_dev
	end
	for j=under_last_i+1,#self.sim.data do
		self.sim.data[j].under_dev = self.sim.data[under_last_i].under_dev
	end

	-- override functions with sim versions
	for i,name in ipairs{'do_meter','init_exposure_params_from_cam','sanity_check_cam_exposure_params','set_cam_exposure_params'} do
		if not self[name] then
			error('bad sim function '..name)
		end
		local sim_name = 'simulate_'..name
		if self[sim_name] then
			self[name] = self[sim_name]
		else
			self[name] = function() end
		end
	end
	self.do_draw = false
end
-- end exp simulation module

function restore()
	disp:enable(true);
	if image_size_save then
		set_prop(props.RESOLUTION,image_size_save)
	end
	if raw_enable_save then
		set_raw(raw_enable_save)
	end
	if usb_remote_enable_save then
		set_config_value(require'GEN/cnf_core'.remote_enable,usb_remote_enable_save)
	end
	log:close()
end

-- main script initialization
if not ui_sim then
	local rec, vid = get_mode()
	if not rec then
		print("switching to rec")
		sleep(1000)
		set_record(true)
		repeat sleep(10) until get_mode()
		sleep(500)
		rec, vid = get_mode()
	end
	if vid then
		error('not in still mode')
	end
end

log:init{
	name="A/rawopint.csv",
	append=(ui_log_mode.value=='Append'),
	dummy=(ui_log_mode.value=='None'),
	-- column names
	cols={
		'date',
		'time',
		'tick',
		'exp',
		'start',
		'shoot_ready',
		'sleep',
		'exp_start',
		'raw_ready',
		'meter_time',
		'histo_time',
		'draw_time',
		'raw_done',
		'vbatt',
		'tsensor',
		'topt',
		'tbatt',
		'free_mem',
		'lua_mem',
		'sd_space',
		'sv',
		'sv96',
		'tv',
		'tv96',
		'av',
		'av96',
		'nd',
		'bv96',
		'meter',
		'meter96',
		'meter_weight',
		'over_frac',
		'over_weight',
		'under_frac',
		'under_weight',
		'bv_ev_shift',
		'd_ev',
		'desc',
	},
	-- columns automatically set at write time from functions
	funcs={
		date=function()
			return os.date('%m/%d/%Y')
		end,
		time=function()
			return os.date('%H:%M:%S')
		end,
		tick=get_tick_count,
		exp=get_exp_count,
		vbatt=get_vbatt,
		tsensor=function()
			return get_temperature(1)
		end,
		topt=function()
			return get_temperature(0)
		end,
		tbatt=function()
			return get_temperature(2)
		end,
		free_mem=function()
			return get_meminfo().free_size
		end,
		lua_mem=function()
			return collectgarbage('count')
		end,
		sd_space=get_free_disk_space,
	},
	-- columns collected in a table, concatenated at write time
	tables={
		desc=' / ',
	},
}
logtime=log:dt_logger('start')
logdesc=log:text_logger('desc')

shutdown:init{
	finish=ui_shutdown_finish,
	lowbat=ui_shutdown_lowbat,
	lowspace=ui_shutdown_lowspace,
}

exp:init{
	meter_width_pct=ui_meter_width_pct,
	meter_height_pct=ui_meter_height_pct,
	meter_step=ui_meter_step,

	ev_change_max=ui_max_ev_change,
	ev_shift=ui_ev_shift, -- shift target ev by x APEX96
	ev_use_initial=ui_ev_use_initial, -- use initial EV as target ev, modified by ev_shift if specified
	bv_ev_shift_pct=ui_bv_ev_shift_pct, -- shift ev proportional to abosolute scene brightness
	bv_ev_shift_base_bv=ui_bv_ev_shift_base_bv, -- absolute scene brightness for initial target ev (direct sun = ~10)
	-- max (longest) shutter value
	tv96_long_limit=usec_to_tv96(ui_tv_max_s1k*1000),
	-- min (shortest) shutter value
	tv96_short_limit=usec_to_tv96(ui_tv_min_s100k*10),
	-- shutter value to start adjusting iso
	tv96_sv_thresh=usec_to_tv96(ui_tv_sv_adj_s1k*1000),

	-- shutter value to put in ND
	tv96_nd_thresh=usec_to_tv96(ui_tv_nd_thresh_s10k*100),

	nd_value=ui_nd_value,
	nd_force=ui_nd_force,
	nd_hysteresis=ui_nd_hysteresis,
	-- max iso
	sv96_max=sv96_market_to_real(iso_to_sv96(ui_sv_max_mkt)),
	-- target iso
	sv96_target=sv96_market_to_real(iso_to_sv96(ui_sv_target_mkt)),

-- prefer low or high aperture
-- TODO not implemented
--av_target_low = (av_target.value == 0)


	-- point where high meter value starts increasing meter weight,
	meter_high_thresh = ui_meter_high_thresh,
	-- point where full weight increase is reached
	meter_high_limit = ui_meter_high_limit,
	-- weight at limit
	meter_high_limit_weight = ui_meter_high_limit_weight,
	
	-- point where low meter value starts increasing meter weight
	meter_low_thresh = ui_meter_low_thresh,
	-- point where full weight increase is reached
	meter_low_limit = ui_meter_low_limit,
	-- weight at limit
	meter_low_limit_weight = ui_meter_low_limit_weight,
	
    -- how close to max shot histo to count against over exp fraction
	over_margin_ev=ui_exp_over_margin_ev,
  
    -- under is defined in terms of EV under neutral, since there are a bunch of stops without useful DR near black level
	under_margin_ev=ui_exp_under_margin_ev, 

	-- histo is measured in parts per million, inputs in parts per 100k
	over_thresh_frac=ui_exp_over_thresh_frac*10,
	under_thresh_frac=ui_exp_under_thresh_frac*10,

	over_weight_max=ui_exp_over_weight_max,
	over_prio=ui_exp_over_prio,

	under_weight_max=ui_exp_under_weight_max,
	under_prio=ui_exp_under_prio,

	histo_step=ui_histo_step,
	do_draw=ui_do_draw,
	draw_meter=string.lower(ui_draw_meter_t.value),
	draw_gauge_y_pct=ui_draw_gauge_y_pct,
	smooth=true,
}

function run_sim()
	local count,ms=set_yield(-1,50)
	-- ignore shutdown options for sim
	shutdown.opts.finish = false
	exp:sim_init()
	local i=1
	local total = #exp.sim.data
	repeat
		print("sim",i,"/",total)
		wait_click(10)
		if is_key('menu') then
			logdesc('user exit')
			log:write()
			break
		end
		exp:run()
		log:write()
		collectgarbage('step')
		i=i+1
	until not exp.sim.data[exp.sim.frame+1]
	set_yield(count,ms)
end

function log_preshoot_values()
	local dof=get_dofinfo()
	logdesc('sd:%d af_ok:%s fl:%d efl:%d zoom_pos:%d',
			dof.focus,tostring(get_focus_ok()),dof.focal_length,dof.eff_focal_length,get_zoom())
end

function run()
	local bi=get_buildinfo()
	logdesc("rawopint v:%s",rawopint_version);
	logdesc("platform:%s-%s-%s-%s %s %s",
						bi.platform,bi.platsub,bi.build_number,bi.build_revision,
						bi.build_date,bi.build_time)
	logdesc('interval:%d',interval)

	if ui_raw_hook_sleep > 0 then
		logdesc('rawhooksleep:%d',ui_raw_hook_sleep)
	end

	local yield_save_count, yield_save_ms
	if ui_noyield then
		logdesc('noyield')
		yield_save_count, yield_save_ms = set_yield(-1,-1)
	end
	if image_size then
		image_size_save = get_prop(props.RESOLUTION)
		set_prop(props.RESOLUTION,image_size)
	end
	if use_raw then
		raw_enable_save = get_raw()
		set_raw(use_raw)
	end

	local cont = ui_use_cont and get_prop(props.DRIVE_MODE) == 1
	if cont then
		logdesc('cont_mode')
	end

	-- set initial display state
	disp:update()

	-- set the hook just before shutter release for timing
	hook_shoot.set(10000)
	-- if using remote, make sure shoot hook will wait longer than timeout interval
	if ui_use_remote then
		logdesc("USB remote")
		usb_remote_enable_save = get_config_value(require'GEN/cnf_core'.remote_enable)
		set_config_value(require'GEN/cnf_core'.remote_enable,1)
		if interval > 9000 then
			hook_shoot.set(interval + 1000)
		end
		-- TODO set remote config values as needed
	end
	-- set hook in raw for exposure
	hook_raw.set(10000)

	exp:init_before_preshoot()

	press('shoot_half')

	repeat sleep(10) until get_shooting()

	exp:init_preshoot()

	log_preshoot_values()

	log:write()
	
	-- 0 = no limit, end on space, power etc
	if ui_shots == 0 then
		ui_shots = 100000000
	end

	if cont then
		press('shoot_full_only')
	end
	local user_exit
	for i=1,ui_shots do
		-- poll / reset click state
		-- camera will generally take while to be ready for next shot, so extra wait here shouldn't hurt
		wait_click(10)
		if is_key('menu') then
			user_exit=true
		end
		if user_exit then
			-- prevent shutdown on finish if user abort
			shutdown.opts.finish = false
			logdesc('user exit')
			log:write()
			break
		end
		-- TODO CHDK osd doesn't seem to update in halfshoot, but you can check exposure
		if is_key('set') then
			logdesc('key_set')
			disp:toggle(30000)
		end
		if shutdown:check() then
			logdesc('shutdown:%s',shutdown:reason())
			log:write()
			break
		end

		if not cont then
			press('shoot_full_only')
		end
		local t_start=get_tick_count()
		log:set{start=t_start}
		-- wait until the hook is reached
		hook_shoot.wait_ready()
		logtime('shoot_ready')
		if not cont then
			release('shoot_full_only')
		end
		if ui_use_remote then
			-- using remote, wait for pulse or timeout if not already received
			local t0=get_tick_count()
			local timeout = t0+interval
			while get_usb_power(0) == 0 do
				-- allow menu to exit (will take one more shot)
				-- normal exit hard to hit, because remote pulse counts as key
				wait_click(10)
				if is_key('menu') then
					logdesc('remote quit')
					user_exit=true
					break
				end 
				if get_tick_count() > timeout then
					logdesc('remote timeout')
					break
				end
			end
			log:set{sleep=get_tick_count()-t0} -- how long remote was waited for?
		else -- not remote
			-- if additional wait is needed to reach the desired interval, wait
			if shot_tick then
				-- local et = get_tick_count() - shot_tick
				local sleepms = interval - get_tick_count() + shot_tick
				if sleepms > 0 then
					sleep(sleepms)
				elseif interval > 0 then -- if specific interval set, warn if not achieved
					if ui_interval_warn_led then
						set_led(ui_interval_warn_led,1)
					end
					if ui_interval_warn_beep then
						play_sound(4)
					end
				end
				log:set{sleep=sleepms} -- negative == late
			end
		end
		-- record time
		shot_tick = get_tick_count()
		logtime('exp_start') -- the moment the exposure started, because hey, why not?
		-- allow shooting to proceed
		hook_shoot.continue()

		disp:update()

		-- wait for the image to be captured
		hook_raw.wait_ready()
		logtime('raw_ready')

		-- if warning LED specified, make sure it's turned off here
		if ui_interval_warn_led then
			set_led(ui_interval_warn_led,0)
		end

		exp:run()
		-- TODO D10 sometimes fails to open shutter if this is off and debug drawing is disabled, and set_yield is not used
		if ui_raw_hook_sleep > 0 then
			sleep(ui_raw_hook_sleep) 
		end
		hook_raw.continue()
		logtime('raw_done')
		log:write()
		-- encourage garbage collection at a predictable point
		-- TODO should do full collect in sleep time if avail, otherwise step
		collectgarbage('step')
	end
	-- clear hooks
	hook_shoot.set(0)
	hook_raw.set(0)

	if yield_save_count then
		set_yield(yield_save_count,yield_save_ms)
	end
	release('shoot_full')
end

if ui_sim then
	run_sim()
else
	run()
end
-- allow final shot to end before restore + possible shutdown
repeat sleep(10) until not get_shooting()
sleep(1000)

restore()
shutdown:finish()
