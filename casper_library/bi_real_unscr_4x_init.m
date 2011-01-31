function bi_real_unscr_4x_init(blk, varargin)
% Initialize and configure a bi_real_unscr_4x block.
% 
% bi_real_unscr_4x_init(blk, varargin)
% 
% blk = the block to configure
% varargin = {'varname', 'value', ...} pairs
% 
% Valid varnames:
% * FFTSize = Size of the FFT (2^FFTSize points).
% * n_bits = Data bitwidth.
% * add_latency = Latency of adders blocks.
% * conv_latency = Latency of cast blocks.
% * bram_latency = Latency of BRAM blocks.
% * bram_map = Store map in BRAM.
% * bram_delays = Implement delays in BRAM.
% * dsp48_adders = Use DSP48s for adders.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                             %
%   Center for Astronomy Signal Processing and Electronics Research           %
%   http://casper.berkeley.edu                                                %
%   Copyright (C) 2010 William Mallard                                        %
%                                                                             %
%   This program is free software; you can redistribute it and/or modify      %
%   it under the terms of the GNU General Public License as published by      %
%   the Free Software Foundation; either version 2 of the License, or         %
%   (at your option) any later version.                                       %
%                                                                             %
%   This program is distributed in the hope that it will be useful,           %
%   but WITHOUT ANY WARRANTY; without even the implied warranty of            %
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the             %
%   GNU General Public License for more details.                              %
%                                                                             %
%   You should have received a copy of the GNU General Public License along   %
%   with this program; if not, write to the Free Software Foundation, Inc.,   %
%   51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.               %
%                                                                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set default vararg values.
defaults = { ...
    'FFTSize', 2, ...
    'n_bits', 18, ...
    'add_latency', 1, ...
    'conv_latency', 1, ...
    'bram_latency', 2, ...
    'bram_map', 'off', ...
    'bram_delays', 'off', ...
    'dsp48_adders', 'off', ...
};

% Skip init script if mask state has not changed.
if same_state(blk, 'defaults', defaults, varargin{:}),
  return
end

% Verify that this is the right mask for the block.
check_mask_type(blk, 'bi_real_unscr_4x');

% Disable link if state changes from default.
munge_block(blk, varargin{:});

% Retrieve values from mask fields.
FFTSize = get_var('FFTSize', 'defaults', defaults, varargin{:});
n_bits = get_var('n_bits', 'defaults', defaults, varargin{:});
add_latency = get_var('add_latency', 'defaults', defaults, varargin{:});
conv_latency = get_var('conv_latency', 'defaults', defaults, varargin{:});
bram_latency = get_var('bram_latency', 'defaults', defaults, varargin{:});
bram_map = get_var('bram_map', 'defaults', defaults, varargin{:});
bram_delays = get_var('bram_delays', 'defaults', defaults, varargin{:});
dsp48_adders = get_var('dsp48_adders', 'defaults', defaults, varargin{:});

% Generate reorder maps.
map_even = bit_reverse(0:2^(FFTSize-1)-1, FFTSize-1);
map_odd = bit_reverse(2^(FFTSize-1)-1:-1:0, FFTSize-1);
map_out = 2^(FFTSize-1)-1:-1:0;

% Set mirror_spectrum latencies.
if strcmp(dsp48_adders, 'on'),
    ms_input_latency = 1;
    ms_negate_latency = 1;
else
    ms_input_latency = 0;
    ms_negate_latency = 0;
end

%%%%%%%%%%%%%%%%%%
% Start drawing! %
%%%%%%%%%%%%%%%%%%

% Delete all lines.
delete_lines(blk);

%
% Add inputs and outputs.
%

reuse_block(blk, 'sync', 'built-in/inport', ...
    'Position', [15 13 45 27], ...
    'Port', '1');
reuse_block(blk, 'even', 'built-in/inport', ...
    'Position', [15 238 45 252], ...
    'Port', '2');
reuse_block(blk, 'odd', 'built-in/inport', ...
    'Position', [15 363 45 377], ...
    'Port', '3');

reuse_block(blk, 'sync_out', 'built-in/outport', ...
    'Position', [1200 33 1230 47], ...
    'Port', '1');
reuse_block(blk, 'pol1_out', 'built-in/outport', ...
    'Position', [1200 78 1230 92], ...
    'Port', '2');
reuse_block(blk, 'pol2_out', 'built-in/outport', ...
    'Position', [1200 123 1230 137], ...
    'Port', '3');
reuse_block(blk, 'pol3_out', 'built-in/outport', ...
    'Position', [1200 168 1230 182], ...
    'Port', '4');
reuse_block(blk, 'pol4_out', 'built-in/outport', ...
    'Position', [1200 213 1230 227], ...
    'Port', '5');

%
% Add reorder blocks.
%

reuse_block(blk, 'en_even', 'xbsIndex_r4/Constant', ...
    'Position', [15 210 45 230], ...
    'ShowName', 'off', ...
    'arith_type', 'Boolean', ...
    'const', '1', ...
    'n_bits', '1', ...
    'bin_pt', '0', ...
    'explicit_period', 'on', ...
    'period', '1');

reuse_block(blk, 'reorder_even', 'casper_library_reorder/reorder', ...
    'Position', [100 182 175 258], ...
    'LinkStatus', 'inactive', ...
    'map', mat2str(map_even), ...
    'n_inputs', '1', ...
    'bram_latency', 'bram_latency',...
    'map_latency', '0', ...
    'double_buffer', '0', ...
    'bram_map', bram_map);

reuse_block(blk, 'en_odd', 'xbsIndex_r4/Constant', ...
    'Position', [15 335 45 355], ...
    'ShowName', 'off', ...
    'arith_type', 'Boolean', ...
    'const', '1', ...
    'n_bits', '1', ...
    'bin_pt', '0', ...
    'explicit_period', 'on', ...
    'period', '1');

reuse_block(blk, 'reorder_odd', 'casper_library_reorder/reorder', ...
    'Position', [100 307 175 383], ...
    'LinkStatus', 'inactive', ...
    'map', mat2str(map_odd), ...
    'n_inputs', '1', ...
    'bram_latency', 'bram_latency', ...
    'map_latency', '0', ...
    'double_buffer', '0', ...
    'bram_map', bram_map);

%
% Add mux control logic.
%

reuse_block(blk, 'Counter0', 'xbsIndex_r4/Counter', ...
    'Position', [215 85 260 105], ...
    'ShowName', 'off', ...
    'cnt_type', 'Free Running', ...
    'cnt_to', 'Inf', ...
    'operation', 'Up', ...
    'start_count', '0', ...
    'cnt_by_val', '1', ...
    'arith_type', 'Unsigned', ...
    'n_bits', 'FFTSize', ...
    'bin_pt', '0', ...
    'load_pin', 'off', ...
    'rst', 'on', ...
    'en', 'off', ...
    'explicit_period', 'on', ...
    'period', '1', ...
    'use_behavioral_HDL', 'off', ...
    'implementation', 'Fabric');...

reuse_block(blk, 'Constant0', 'xbsIndex_r4/Constant', ...
    'Position', [225 25 255 45], ...
    'ShowName', 'off', ...
    'arith_type', 'Unsigned', ...
    'const', '2^(FFTSize-1)', ...
    'n_bits', 'FFTSize', ...
    'bin_pt', '0', ...
    'explicit_period', 'on', ...
    'period', '1');

reuse_block(blk, 'Relational0', 'xbsIndex_r4/Relational', ...
    'Position', [300 20 350 70], ...
    'ShowName', 'off', ...
    'mode', 'a=b', ...
    'en', 'off', ...
    'latency', '0');

reuse_block(blk, 'Constant1', 'xbsIndex_r4/Constant', ...
    'Position', [225 110 255 130], ...
    'ShowName', 'off', ...
    'arith_type', 'Unsigned', ...
    'const', '0', ...
    'n_bits', 'FFTSize', ...
    'bin_pt', '0', ...
    'explicit_period', 'on', ...
    'period', '1');

reuse_block(blk, 'Relational1', 'xbsIndex_r4/Relational', ...
    'Position', [300 80 350 130], ...
    'ShowName', 'off', ...
    'mode', 'a=b', ...
    'en', 'off', ...
    'latency', '0');

reuse_block(blk, 'Delay', 'xbsIndex_r4/Delay', ...
    'Position', [225 360 255 380], ...
    'ShowName', 'off', ...
    'latency', '1', ...
    'reg_retiming', 'off');

%
% Add mux blocks.
%

reuse_block(blk, 'Mux0', 'xbsIndex_r4/Mux', ...
    'Position', [475 150 500 216], ...
    'inputs', '2', ...
    'en', 'off', ...
    'latency', '1', ...
    'Precision', 'Full');

reuse_block(blk, 'Mux1', 'xbsIndex_r4/Mux', ...
    'Position', [475 250 500 316], ...
    'inputs', '2', ...
    'en', 'off', ...
    'latency', '1', ...
    'Precision', 'Full');

reuse_block(blk, 'Mux2', 'xbsIndex_r4/Mux', ...
    'Position', [475 350 500 416], ...
    'inputs', '2', ...
    'en', 'off', ...
    'latency', '1', ...
    'Precision', 'Full');

reuse_block(blk, 'Mux3', 'xbsIndex_r4/Mux', ...
    'Position', [475 450 500 516], ...
    'inputs', '2', ...
    'en', 'off', ...
    'latency', '1', ...
    'Precision', 'Full');

%
% Add sync_delay block.
%

sync_delay = '2^(FFTSize-1) + add_latency + conv_latency + 1';

% If the sync delay requires more than four slices,
% then implement it as a counter.
%
% 1 FF + 3 * (SRL16 + FF) ---> 1 + 3 * (16 + 1) = 52

if (eval(sync_delay) > 52),
    sync_delay_name = 'sync_delay_ctr';
    reuse_block(blk, sync_delay_name, 'casper_library_delays/sync_delay', ...
        'Position', [550 70 600 90], ...
        'LinkStatus', 'inactive', ...
        'DelayLen', sync_delay);
else
    sync_delay_name = 'sync_delay_srl';
    reuse_block(blk, sync_delay_name, 'casper_library_delays/delay_srl', ...
        'Position', [550 70 600 90], ...
        'LinkStatus', 'inactive', ...
        'DelayLen', sync_delay);
end

%
% Add hilbert blocks.
%

if strcmp(dsp48_adders, 'on'),
    hilbert_name = 'hilbert_dsp48e';
    reuse_block(blk, [hilbert_name, '0'], 'casper_library_ffts_internal/hilbert_dsp48e', ...
        'Position', [550 200 600 250], ...
        'LinkStatus', 'inactive', ...
        'BitWidth', 'n_bits', ...
        'conv_latency', 'conv_latency');
    reuse_block(blk, [hilbert_name, '1'], 'casper_library_ffts_internal/hilbert_dsp48e', ...
        'Position', [550 400 600 450], ...
        'LinkStatus', 'inactive', ...
        'BitWidth', 'n_bits', ...
        'conv_latency', 'conv_latency');
else
    hilbert_name = 'hilbert';
    reuse_block(blk, [hilbert_name, '0'], 'casper_library_ffts_internal/hilbert', ...
        'Position', [550 200 600 250], ...
        'LinkStatus', 'inactive', ...
        'BitWidth', 'n_bits', ...
        'add_latency', 'add_latency', ...
        'conv_latency', 'conv_latency');
    reuse_block(blk, [hilbert_name, '1'], 'casper_library_ffts_internal/hilbert', ...
        'Position', [550 400 600 450], ...
        'LinkStatus', 'inactive', ...
        'BitWidth', 'n_bits', ...
        'add_latency', 'add_latency', ...
        'conv_latency', 'conv_latency');
end

%
% Add delay blocks.
%

if strcmp(bram_delays, 'on'),
    delay_name = 'delay_bram';
    reuse_block(blk, [delay_name, '0'], 'casper_library_delays/delay_bram', ...
        'Position', [650 205 700 225], ...
        'LinkStatus', 'inactive', ...
        'NamePlacement', 'alternate', ...
        'DelayLen', '2^(FFTSize-1)', ...
        'bram_latency', 'bram_latency');
    reuse_block(blk, [delay_name, '1'], 'casper_library_delays/delay_bram', ...
        'Position', [650 230 700 250], ...
        'LinkStatus', 'inactive', ...
        'DelayLen', '2^(FFTSize-1)', ...
        'bram_latency', 'bram_latency');
else
    delay_name = 'delay_srl';
    reuse_block(blk, [delay_name, '0'], 'casper_library_delays/delay_srl', ...
        'Position', [650 205 700 225], ...
        'LinkStatus', 'inactive', ...
        'NamePlacement', 'alternate', ...
        'DelayLen', '2^(FFTSize-1)');
    reuse_block(blk, [delay_name, '1'], 'casper_library_delays/delay_srl', ...
        'Position', [650 230 700 250], ...
        'LinkStatus', 'inactive', ...
        'DelayLen', '2^(FFTSize-1)');
end

%
% Add mux reorder and mirror_spectrum blocks.
%

reuse_block(blk, 'reorder_out', 'casper_library_reorder/reorder', ...
    'Position', [825 301 900 454], ...
    'LinkStatus', 'inactive', ...
    'map', mat2str(map_out), ...
    'n_inputs', '4', ...
    'bram_latency', 'bram_latency', ...
    'map_latency', '0', ...
    'double_buffer', '0', ...
    'bram_map', bram_map);

reuse_block(blk, 'en_out', 'xbsIndex_r4/Constant', ...
    'Position', [650 330 680 350], ...
    'ShowName', 'off', ...
    'arith_type', 'Boolean', ...
    'const', '1', ...
    'n_bits', '1', ...
    'bin_pt', '0', ...
    'explicit_period', 'on', ...
    'period', '1');

reuse_block(blk, 'mirror_spectrum', 'casper_library_ffts_internal/mirror_spectrum', ...
    'Position', [1050 18 1150 241], ...
    'LinkStatus', 'inactive', ...
    'FFTSize', num2str(FFTSize), ...
    'input_bitwidth', num2str(n_bits), ...
    'bram_latency', num2str(bram_latency), ...
    'negate_latency', num2str(ms_negate_latency));

for i = 0:8,
    name = ['delay_ms', num2str(i+1)];
    reuse_block(blk, name, 'xbsIndex_r4/Delay', ...
        'Position', [950 23+i*25 1000 37+i*25], ...
        'ShowName', 'off', ...
        'latency', num2str(ms_input_latency), ...
        'reg_retiming', 'off');
end

%
% Draw wires.
%

add_line(blk, 'sync/1', 'reorder_even/1');
add_line(blk, 'en_even/1', 'reorder_even/2');
add_line(blk, 'even/1', 'reorder_even/3');

add_line(blk, 'sync/1', 'reorder_odd/1');
add_line(blk, 'en_odd/1', 'reorder_odd/2');
add_line(blk, 'odd/1', 'reorder_odd/3');

add_line(blk, 'reorder_odd/3', 'Delay/1');
add_line(blk, 'reorder_even/1', 'Counter0/1');

add_line(blk, 'Constant0/1', 'Relational0/1');
add_line(blk, 'Counter0/1', 'Relational0/2');
add_line(blk, 'Counter0/1', 'Relational1/1');
add_line(blk, 'Constant1/1', 'Relational1/2');

add_line(blk, 'Relational0/1', 'Mux0/1');
add_line(blk, 'Relational1/1', 'Mux1/1');
add_line(blk, 'Relational1/1', 'Mux2/1');
add_line(blk, 'Relational0/1', 'Mux3/1');

add_line(blk, 'reorder_even/3', 'Mux0/2');
add_line(blk, 'reorder_even/3', 'Mux1/3');
add_line(blk, 'reorder_even/3', 'Mux2/2');
add_line(blk, 'reorder_even/3', 'Mux3/3');

add_line(blk, 'Delay/1', 'Mux0/3');
add_line(blk, 'Delay/1', 'Mux1/2');
add_line(blk, 'Delay/1', 'Mux2/3');
add_line(blk, 'Delay/1', 'Mux3/2');

add_line(blk, 'Mux0/1', [hilbert_name, '0/1']);
add_line(blk, 'Mux1/1', [hilbert_name, '0/2']);
add_line(blk, 'Mux2/1', [hilbert_name, '1/1']);
add_line(blk, 'Mux3/1', [hilbert_name, '1/2']);

add_line(blk, [hilbert_name, '0/1'], [delay_name, '0/1']);
add_line(blk, [hilbert_name, '0/2'], [delay_name, '1/1']);

add_line(blk, [sync_delay_name, '/1'], 'reorder_out/1');
add_line(blk, 'en_out/1', 'reorder_out/2');
add_line(blk, [delay_name, '0/1'], 'reorder_out/3');
add_line(blk, [delay_name, '1/1'], 'reorder_out/4');
add_line(blk, [hilbert_name, '1/1'], 'reorder_out/5');
add_line(blk, [hilbert_name, '1/2'], 'reorder_out/6');

add_line(blk, 'reorder_even/1', [sync_delay_name, '/1']);
add_line(blk, [sync_delay_name, '/1'], 'delay_ms1/1');

add_line(blk, [delay_name, '0/1'], 'delay_ms2/1');
add_line(blk, [delay_name, '1/1'], 'delay_ms4/1');
add_line(blk, [hilbert_name, '1/1'], 'delay_ms6/1');
add_line(blk, [hilbert_name, '1/2'], 'delay_ms8/1');

add_line(blk, 'reorder_out/3', 'delay_ms3/1');
add_line(blk, 'reorder_out/4', 'delay_ms5/1');
add_line(blk, 'reorder_out/5', 'delay_ms7/1');
add_line(blk, 'reorder_out/6', 'delay_ms9/1');

add_line(blk, 'delay_ms1/1', 'mirror_spectrum/1');
add_line(blk, 'delay_ms2/1', 'mirror_spectrum/2');
add_line(blk, 'delay_ms3/1', 'mirror_spectrum/3');
add_line(blk, 'delay_ms4/1', 'mirror_spectrum/4');
add_line(blk, 'delay_ms5/1', 'mirror_spectrum/5');
add_line(blk, 'delay_ms6/1', 'mirror_spectrum/6');
add_line(blk, 'delay_ms7/1', 'mirror_spectrum/7');
add_line(blk, 'delay_ms8/1', 'mirror_spectrum/8');
add_line(blk, 'delay_ms9/1', 'mirror_spectrum/9');

add_line(blk, 'mirror_spectrum/1', 'sync_out/1');
add_line(blk, 'mirror_spectrum/2', 'pol1_out/1');
add_line(blk, 'mirror_spectrum/3', 'pol2_out/1');
add_line(blk, 'mirror_spectrum/4', 'pol3_out/1');
add_line(blk, 'mirror_spectrum/5', 'pol4_out/1');

% Delete all unconnected blocks.
clean_blocks(blk);

%%%%%%%%%%%%%%%%%%%
% Finish drawing! %
%%%%%%%%%%%%%%%%%%%

% Save block state to stop repeated init script runs.
save_state(blk, 'defaults', defaults, varargin{:});

