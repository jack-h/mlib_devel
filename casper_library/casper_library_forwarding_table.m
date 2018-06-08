function out = casper_library_forwarding_table(varargin)
% With no input arguments, this function returns a forwarding table suitable
% for use with casper_library.mdl.
% 
% This script is intended to make it easier to rearrange the casper_library
% library.  "clft" is a cell array of two-element cell arrays, each of
% which specifies the old and new path of a block that has moved.
%
% To update the forwarding table of casper_library.mdl, simply run...
%
% set_param('casper_library';'ForwardingTable',casper_library_forwarding_table);
%
% ...which will completely overwrite the value of the ForwardingTable
% parameter of the casper_library library with the value returned by this
% function.
%
% Don't forget to unlock casper_library beforehand!
% Don't forget to save casper_library afterwards!
%
% With a single argument, look it up in the forwarding table contained in this
% script (but not necessarily in caser_library.mdl if it's gotten out of
% sync...).  If found, return the new name; if not found, return the given name
% unchanged.

% Create forwarding table just one time
persistent clft;
if isempty(clft)
clft = ...
{ ...
{'casper_library/Accumulators/dram_vacc';'casper_library_accumulators/dram_vacc'}, ...
{'casper_library/Accumulators/qdr_vacc';'casper_library_accumulators/qdr_vacc'}, ...
{'casper_library/Accumulators/simple_bram_vacc';'casper_library_accumulators/simple_bram_vacc'}, ...
{'casper_library/Accumulators/vacc_tvg';'casper_library_accumulators/vacc_tvg'}, ...
{'casper_library/Communications/gbe_mux';'casper_library_communications/gbe_mux'}, ...
{'casper_library/Communications/pkt_buf';'casper_library_communications/pkt_buf'}, ...
{'casper_library/Correlator/auto_tap';'casper_library_correlator/auto_tap'}, ...
{'casper_library/Correlator/baseline_tap';'casper_library_correlator/baseline_tap'}, ...
{'casper_library/Correlator/cross_multiplier';'casper_library_correlator/cross_multiplier'}, ...
{'casper_library/Correlator/x_cast';'casper_library_correlator/x_cast'}, ...
{'casper_library/Correlator/xeng';'casper_library_correlator/xeng'}, ...
{'casper_library/Correlator/xeng_conj_fix';'casper_library_correlator/xeng_conj_fix'}, ...
{'casper_library/Correlator/xeng_descramble';'casper_library_correlator/xeng_descramble'}, ...
{'casper_library/Correlator/xeng_descramble_4ant';'casper_library_correlator/xeng_descramble_4ant'}, ...
{'casper_library/Correlator/xeng_tvg';'casper_library_correlator/xeng_tvg'}, ...
{'casper_library/Delays/Datatype_Conv_Cos';'casper_library_delays/Datatype_Conv_Cos'}, ...
{'casper_library/Delays/Datatype_Conv_Sine';'casper_library_delays/Datatype_Conv_Sine'}, ...
{'casper_library/Delays/Fine_del_sub_blk';'casper_library_delays/Fine_del_sub_blk'}, ...
{'casper_library/Delays/Fringe_sub_blk';'casper_library_delays/Fringe_sub_blk'}, ...
{'casper_library/Delays/delay_bram';'casper_library_delays/delay_bram'}, ...
{'casper_library/Delays/delay_bram_en_plus';'casper_library_delays/delay_bram_en_plus'}, ...
{'casper_library/Delays/delay_bram_prog';'casper_library_delays/delay_bram_prog'}, ...
{'casper_library/Delays/delay_bram_prog_dp';'casper_library_delays/delay_bram_prog_dp'}, ...
{'casper_library/Delays/delay_complex';'casper_library_delays/delay_complex'}, ...
{'casper_library/Delays/delay_slr';'casper_library_delays/delay_slr'}, ...
{'casper_library/Delays/delay_wideband_prog';'casper_library_delays/delay_wideband_prog'}, ...
{'casper_library/Delays/finedelay_fstop_prog';'casper_library_delays/finedelay_fstop_prog'}, ...
{'casper_library/Delays/finedelay_fstop_prog_cordic';'casper_library_delays/finedelay_fstop_prog_cordic'}, ...
{'casper_library/Delays/partial_delay_prog';'casper_library_delays/partial_delay_prog'}, ...
{'casper_library/Delays/pipeline';'casper_library_delays/pipeline'}, ...
{'casper_library/Delays/sync_delay';'casper_library_delays/sync_delay'}, ...
{'casper_library/Delays/sync_delay_en';'casper_library_delays/sync_delay_en'}, ...
{'casper_library/Delays/sync_delay_prog';'casper_library_delays/sync_delay_prog'}, ...
{'casper_library/Delays/window_delay';'casper_library_delays/window_delay'}, ...
{'casper_library/Downconverter/dds';'casper_library_downconverter/dds'}, ...
{'casper_library/Downconverter/dec_fir';'casper_library_downconverter/dec_fir'}, ...
{'casper_library/Downconverter/fir_col';'casper_library_downconverter/fir_col'}, ...
{'casper_library/Downconverter/fir_dbl_col';'casper_library_downconverter/fir_dbl_col'}, ...
{'casper_library/Downconverter/fir_dbl_tap';'casper_library_downconverter/fir_dbl_tap'}, ...
{'casper_library/Downconverter/fir_tap';'casper_library_downconverter/fir_tap'}, ...
{'casper_library/Downconverter/lo_const';'casper_library_downconverter/lo_const'}, ...
{'casper_library/Downconverter/lo_osc';'casper_library_downconverter/lo_osc'}, ...
{'casper_library/Downconverter/mixer';'casper_library_downconverter/mixer'}, ...
{'casper_library/Downconverter/rcmult';'casper_library_downconverter/rcmult'}, ...
{'casper_library/Downconverter/sincos';'casper_library_downconverter/sincos'}, ...
{'casper_library/FFTs/biplex_core';'casper_library_ffts/biplex_core'}, ...
{'casper_library/FFTs/butterfly_direct';'casper_library_ffts/butterfly_direct'}, ...
{'casper_library/FFTs/fft';'casper_library_ffts/fft'}, ...
{'casper_library/FFTs/fft_biplex';'casper_library_ffts/fft_biplex'}, ...
{'casper_library/FFTs/fft_biplex_real_2x';'casper_library_ffts/fft_biplex_real_2x'}, ...
{'casper_library/FFTs/fft_biplex_real_4x';'casper_library_ffts/fft_biplex_real_4x'}, ...
{'casper_library/FFTs/fft_direct';'casper_library_ffts/fft_direct'}, ...
{'casper_library/FFTs/fft_stage_n';'casper_library_ffts/fft_stage_n'}, ...
{'casper_library/FFTs/fft_unscrambler';'casper_library_ffts/fft_unscrambler'}, ...
{'casper_library/FFTs/fft_wideband_real';'casper_library_ffts/fft_wideband_real'}, ...
{'casper_library/FFTs/Twiddle/twiddle_coeff_0';'casper_library_ffts_twiddle/twiddle_coeff_0'}, ...
{'casper_library/FFTs/Twiddle/twiddle_coeff_1';'casper_library_ffts_twiddle/twiddle_coeff_1'}, ...
{'casper_library/FFTs/Twiddle/twiddle_general_3mult';'casper_library_ffts_twiddle/twiddle_general_3mult'}, ...
{'casper_library/FFTs/Twiddle/twiddle_general_4mult';'casper_library_ffts_twiddle/twiddle_general_4mult'}, ...
{'casper_library/FFTs/Twiddle/twiddle_pass_through';'casper_library_ffts_twiddle/twiddle_pass_through'}, ...
{'casper_library/FFTs/Twiddle/twiddle_stage_2';'casper_library_ffts_twiddle/twiddle_stage_2'}, ...
{'casper_library/FFTs/Twiddle/coeff_gen/coeff_gen';'casper_library_ffts_twiddle_coeff_gen/coeff_gen'}, ...
{'casper_library/Flow_Control/packetizer';'casper_library_flow_control/packetizer'}, ...
{'casper_library/Flow_Control/parallel_to_serial_converter';'casper_library_flow_control/parallel_to_serial_converter'}, ...
{'casper_library/Flow_Control/shifter_unit';'casper_library_flow_control/shifter_unit'}, ...
{'casper_library/Misc/adc_sim';'casper_library_misc/adc_sim'}, ...
{'casper_library/Misc/adder_tree';'casper_library_misc/adder_tree'}, ...
{'casper_library/Misc/armed_trigger';'casper_library_misc/armed_trigger'}, ...
{'casper_library/Misc/bit_reverse';'casper_library_misc/bit_reverse'}, ...
{'casper_library/Misc/c_to_ri';'casper_library_misc/c_to_ri'}, ...
{'casper_library/Misc/complex_addsub';'casper_library_misc/complex_addsub'}, ...
{'casper_library/Misc/complex_convert';'casper_library_misc/complex_convert'}, ...
{'casper_library/Misc/conv';'casper_library_misc/conv'}, ...
{'casper_library/Misc/convert';'casper_library_misc/convert'}, ...
{'casper_library/Misc/convert_of';'casper_library_misc/convert_of'}, ...
{'casper_library/Misc/edge';'casper_library_misc/edge'}, ...
{'casper_library/Misc/edge_detect';'casper_library_misc/edge_detect'}, ...
{'casper_library/Misc/freeze_cntr';'casper_library_misc/freeze_cntr'}, ...
{'casper_library/Misc/negedge';'casper_library_misc/negedge'}, ...
{'casper_library/Misc/negedge_delay';'casper_library_misc/negedge_delay'}, ...
{'casper_library/Misc/of1';'casper_library_misc/of1'}, ...
{'casper_library/Misc/posedge';'casper_library_misc/posedge'}, ...
{'casper_library/Misc/power';'casper_library_misc/power'}, ...
{'casper_library/Misc/pulse_ext';'casper_library_misc/pulse_ext'}, ...
{'casper_library/Misc/revision_control';'casper_library_misc/revision_control'}, ...
{'casper_library/Misc/ri_to_c';'casper_library_misc/ri_to_c'}, ...
{'casper_library/Misc/sample_and_hold';'casper_library_misc/sample_and_hold'}, ...
{'casper_library/Misc/stopwatch';'casper_library_misc/stopwatch'}, ...
{'casper_library/Misc/sync_gen';'casper_library_misc/sync_gen'}, ...
{'casper_library/Misc/triggered_counter';'casper_library_misc/triggered_counter'}, ...
{'casper_library/Multipliers/cmult';'casper_library_multipliers/cmult'}, ...
{'casper_library/Multipliers/cmult_4bit_br';'casper_library_multipliers/cmult_4bit_br'}, ...
{'casper_library/Multipliers/cmult_4bit_br*';'casper_library_multipliers/cmult_4bit_br*'}, ...
{'casper_library/Multipliers/cmult_4bit_em';'casper_library_multipliers/cmult_4bit_em'}, ...
{'casper_library/Multipliers/cmult_4bit_em*';'casper_library_multipliers/cmult_4bit_em*'}, ...
{'casper_library/Multipliers/cmult_4bit_hdl';'casper_library_multipliers/cmult_4bit_hdl'}, ...
{'casper_library/Multipliers/cmult_4bit_hdl*';'casper_library_multipliers/cmult_4bit_hdl*'}, ...
{'casper_library/Multipliers/cmult_4bit_sl';'casper_library_multipliers/cmult_4bit_sl'}, ...
{'casper_library/Multipliers/cmult_4bit_sl*';'casper_library_multipliers/cmult_4bit_sl*'}, ...
{'casper_library/PFBs/first_tap';'casper_library_pfbs/first_tap'}, ...
{'casper_library/PFBs/first_tap_real';'casper_library_pfbs/first_tap_real'}, ...
{'casper_library/PFBs/last_tap';'casper_library_pfbs/last_tap'}, ...
{'casper_library/PFBs/last_tap_real';'casper_library_pfbs/last_tap_real'}, ...
{'casper_library/PFBs/pfb_coeff_gen';'casper_library_pfbs/pfb_coeff_gen'}, ...
{'casper_library/PFBs/pfb_fir';'casper_library_pfbs/pfb_fir'}, ...
{'casper_library/PFBs/pfb_fir_real';'casper_library_pfbs/pfb_fir_real'}, ...
{'casper_library/PFBs/tap';'casper_library_pfbs/tap'}, ...
{'casper_library/PFBs/tap_real';'casper_library_pfbs/tap_real'}, ...
{'casper_library/Reorder/barrel_switcher';'casper_library_reorder/barrel_switcher'}, ...
{'casper_library/Reorder/dbl_buffer';'casper_library_reorder/dbl_buffer'}, ...
{'casper_library/Reorder/qdr_transpose';'casper_library_reorder/qdr_transpose'}, ...
{'casper_library/Reorder/reorder';'casper_library_reorder/reorder'}, ...
{'casper_library/Reorder/square_transposer';'casper_library_reorder/square_transposer'}, ...
{'casper_library/Scopes/data_capture';'casper_library_scopes/data_capture'}, ...
{'casper_library/Scopes/dsp_scope';'casper_library_scopes/dsp_scope'}, ...
{'casper_library/Scopes/sc';'casper_library_scopes/sc'}, ...
{'casper_library/Scopes/snap';'casper_library_scopes/snap'}, ...
{'casper_library/Scopes/snap64';'casper_library_scopes/snap64'}, ...
{'casper_library/Scopes/snap_10gbe_rx';'casper_library_scopes/snap_10gbe_rx'}, ...
{'casper_library/Scopes/snap_10gbe_tx';'casper_library_scopes/snap_10gbe_tx'}, ...
{'casper_library/Scopes/snap_32n';'casper_library_scopes/snap_32n'}, ...
{'casper_library/Scopes/snap_circ';'casper_library_scopes/snap_circ'}, ...
{'casper_library/Sources/White Gaussian Noise';'casper_library_sources/White Gaussian Noise'}, ...
{'casper_library/Sources/tt800_uprng';'casper_library_sources/tt800_uprng'}, ...
{'casper_library/Sources/u2n';'casper_library_sources/u2n'}, ...
{'xps_library/software_register';'xps_library/Memory/software_register'}, ...
{'xps_library/Shared_BRAM';'xps_library/Memory/Shared_BRAM'}, ...
{'xps_library/ten_Gbe_v2';'xps_library/IO/ten_gbe'}, ...
{'xps_library/one_GbE';'xps_library/IO/one_gbe'}, ...
{'xps_library/forty_gbe';'xps_library/IO/forty_gbe'}, ...
{'xps_library/hmc';'xps_library/Memory/hmc'}, ...
{'xps_library/XAUI';'xps_library/IO/XAUI'}, ...
{'xps_library/dram';'xps_library/Memory/dram'}, ...
{'xps_library/qdr';'xps_library/Memory/qdr'}, ...
{'xps_library/ip';'xps_library/Utilities/ip'}, ...
{'xps_library/dcp';'xps_library/Utilities/dcp'}, ...
{'xps_library/i2c';'xps_library/IO/i2c_interface'}, ...
{'xps_library/gpio';'xps_library/IO/gpio'}, ...
{'xps_library/ADCs/adc16x250-8';'xps_library/ADCs/adc16x250_8'}, ... 
{'xps_library/ADCs/adc1x1800-10';'xps_library/ADCs/adc1x1800_10'}, ...
};
end % ifempty(clft)

if nargin == 0
  out = clft;
else
  out = varargin{1};
  for k = 1:length(clft)
    if strcmp(clft{k}{1}, out)
      out = clft{k}{2};
      break;
    end
  end
end

end
