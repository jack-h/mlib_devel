%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                             %
%   Center for Astronomy Signal Processing and Electronics Research           %
%   http://seti.ssl.berkeley.edu/casper/                                      %
%   Copyright (C) 2007 Terry Filiba, Aaron Parsons                            %
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

function first_tap_mux_init(blk, varargin)
% Initialize and configure the first tap of the Polyphase Filter Bank.
%
% first_tap_mux_init(blk, varargin)
%
% blk = The block to configure.
% varargin = {'varname', 'value', ...} pairs
% 
% Valid varnames for this block are:
% nput = Which input this is
% PFBSize = The size of the PFB
% mux_inputs = number of signals per input
% CoeffBitWidth = Bitwidth of Coefficients.
% TotalTaps = Total number of taps in the PFB
% BitWidthIn = Input Bitwidth
% CoeffDistMem = Implement coefficients in distributed memory
% WindowType = The type of windowing function to use.
% mult_latency = Latency through each multiplier
% bram_latency = Latency through each BRAM.
% n_inputs = The number of parallel inputs
% fwidth = Scaling of the width of each PFB channel

% Declare any default values for arguments you might like.
defaults = {};
if same_state(blk, 'defaults', defaults, varargin{:}), return, end
check_mask_type(blk, 'first_tap_mux');
munge_block(blk, varargin{:});

propagate_vars([blk,'/pfb_mux_coeff_gen'], 'defaults', defaults, varargin{:});

nput = get_var('nput', 'defaults', defaults, varargin{:});
TotalTaps = get_var('TotalTaps', 'defaults', defaults, varargin{:});
use_hdl = get_var('use_hdl','defaults', defaults, varargin{:});
use_embedded = get_var('use_embedded','defaults', defaults, varargin{:});

set_param([blk,'/Mult'],'use_embedded',use_embedded);
set_param([blk,'/Mult'],'use_behavioral_HDL',use_hdl);
set_param([blk,'/Mult1'],'use_embedded',use_embedded);
set_param([blk,'/Mult1'],'use_behavioral_HDL',use_hdl)

fmtstr = sprintf('input=%d, taps=%d', nput, TotalTaps);
set_param(blk, 'AttributesFormatString', fmtstr);
save_state(blk, 'defaults', defaults, varargin{:});

