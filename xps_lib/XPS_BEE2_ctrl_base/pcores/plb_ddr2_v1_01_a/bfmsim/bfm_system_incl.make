#################################################################
# Makefile generated by Xilinx Platform Studio 
# Project:/home/alschult/BEE2_BSP/repository/pcores/plb_ddr2_v1_01_a/bfmsim/bfm_system.xmp
#################################################################

XILINX_EDK_DIR = /opt/EDK

SYSTEM = bfm_system

MHSFILE = bfm_system.mhs

MSSFILE = bfm_system.mss

FPGA_ARCH = virtex2p

DEVICE = xc2vp4fg456-6

LANGUAGE = vhdl

SEARCHPATHOPT = 

SUBMODULE_OPT = 

PLATGEN_OPTIONS = -p $(DEVICE) -lang $(LANGUAGE) $(SEARCHPATHOPT) $(SUBMODULE_OPT)

LIBGEN_OPTIONS = -mhs $(MHSFILE) -p $(DEVICE) $(SEARCHPATHOPT)

VPGEN_OPTIONS = -p $(DEVICE) $(SEARCHPATHOPT)

MICROBLAZE_BOOTLOOP = $(XILINX_EDK_DIR)/sw/lib/microblaze/mb_bootloop.elf
PPC405_BOOTLOOP = $(XILINX_EDK_DIR)/sw/lib/ppc405/ppc_bootloop.elf
BOOTLOOP_DIR = bootloops

BRAMINIT_ELF_FILES =  
BRAMINIT_ELF_FILE_ARGS =  

ALL_USER_ELF_FILES = 

SIM_CMD = vsim

BEHAVIORAL_SIM_SCRIPT = simulation/behavioral/$(SYSTEM).do

STRUCTURAL_SIM_SCRIPT = simulation/structural/$(SYSTEM).do

TIMING_SIM_SCRIPT = simulation/timing/$(SYSTEM).do

DEFAULT_SIM_SCRIPT = $(BEHAVIORAL_SIM_SCRIPT)

MIX_LANG_SIM_OPT = -mixed yes

SIMGEN_OPTIONS = -p $(DEVICE) -lang $(LANGUAGE) $(SEARCHPATHOPT) $(SUBMODULE_OPT) $(BRAMINIT_ELF_FILE_ARGS) $(MIX_LANG_SIM_OPT)  -s mti


LIBRARIES = 
VPEXEC = virtualplatform/vpexec

LIBSCLEAN_TARGETS = 

PROGRAMCLEAN_TARGETS = 

CORE_STATE_DEVELOPMENT_FILES = 

WRAPPER_NGC_FILES = implementation/plb_bus_wrapper.ngc

POSTSYN_NETLIST = implementation/$(SYSTEM).edn

SYSTEM_BIT = implementation/$(SYSTEM).bit

DOWNLOAD_BIT = implementation/download.bit

SYSTEM_ACE = implementation/$(SYSTEM).ace

UCF_FILE = data/bfm_system.ucf

BMM_FILE = implementation/$(SYSTEM).bmm

FASTRUNTIME_OPT_FILE = etc/fast_runtime.opt
BITGEN_UT_FILE = etc/bitgen.ut
