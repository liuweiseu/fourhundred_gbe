# Set the reference directory for source file relative paths (by default the value is script directory path)
set origin_dir "/home/wei"

# Set 'sources_1' fileset object
set obj [get_filesets sources_1]
set files [list \
 [file normalize "${origin_dir}/Projects/400G/vivado_proj_2023.1/400G_sim/fourhundred_gbe/axi_regs.v"] \
 [file normalize "${origin_dir}/Projects/400G/vivado_proj_2023.1/400G_sim/fourhundred_gbe/axis_data_gen.v"] \
 [file normalize "${origin_dir}/Projects/400G/vivado_proj_2023.1/400G_sim/fourhundred_gbe/kutleng_skarab2_bsp_firmware/casperbsp/sources/vhdl/rtl/macphy/dcmactop.v"] \
 [file normalize "${origin_dir}/Projects/400G/vivado_proj_2023.1/400G_sim/fourhundred_gbe/reg_delay.v"] \
 [file normalize "${origin_dir}/Projects/400G/vivado_proj_2023.1/400G_sim/fourhundred_gbe/kutleng_skarab2_bsp_firmware/casperbsp/sources/vhdl/rtl/arp/arpcache.vhd"] \
 [file normalize "${origin_dir}/Projects/400G/vivado_proj_2023.1/400G_sim/fourhundred_gbe/kutleng_skarab2_bsp_firmware/casperbsp/sources/vhdl/rtl/arp/arpramadpwr.vhd"] \
 [file normalize "${origin_dir}/Projects/400G/vivado_proj_2023.1/400G_sim/fourhundred_gbe/kutleng_skarab2_bsp_firmware/casperbsp/sources/vhdl/rtl/arp/arpramadpwrr.vhd"] \
 [file normalize "${origin_dir}/Projects/400G/vivado_proj_2023.1/400G_sim/fourhundred_gbe/kutleng_skarab2_bsp_firmware/casperbsp/sources/vhdl/rtl/udp/axioffseter400g.vhd"] \
 [file normalize "${origin_dir}/Projects/400G/vivado_proj_2023.1/400G_sim/fourhundred_gbe/kutleng_skarab2_bsp_firmware/casperbsp/sources/vhdl/rtl/udp/axis_data_fifo_400g.vhd"] \
 [file normalize "${origin_dir}/Projects/400G/vivado_proj_2023.1/400G_sim/fourhundred_gbe/kutleng_skarab2_bsp_firmware/casperbsp/sources/vhdl/rtl/udp/macinterface/axisfabricmultiplexer.vhd"] \
 [file normalize "${origin_dir}/Projects/400G/vivado_proj_2023.1/400G_sim/fourhundred_gbe/kutleng_skarab2_bsp_firmware/casperbsp/sources/vhdl/rtl/udp/macinterface/axistwoportfabricmultiplexer.vhd"] \
 [file normalize "${origin_dir}/Projects/400G/vivado_proj_2023.1/400G_sim/fourhundred_gbe/kutleng_skarab2_bsp_firmware/casperbsp/sources/vhdl/rtl/udp/casper400gethernetblock_no_cpu.vhd"] \
 [file normalize "${origin_dir}/Projects/400G/vivado_proj_2023.1/400G_sim/fourhundred_gbe/kutleng_skarab2_bsp_firmware/casperbsp/sources/vhdl/rtl/ringbuffer/cpudualportpacketringbuffer.vhd"] \
 [file normalize "${origin_dir}/Projects/400G/vivado_proj_2023.1/400G_sim/fourhundred_gbe/kutleng_skarab2_bsp_firmware/casperbsp/sources/vhdl/rtl/udp/macinterface/cpuethernetmacif400g.vhd"] \
 [file normalize "${origin_dir}/Projects/400G/vivado_proj_2023.1/400G_sim/fourhundred_gbe/kutleng_skarab2_bsp_firmware/casperbsp/sources/vhdl/rtl/ringbuffer/cpuifreceiverpacketringbuffer.vhd"] \
 [file normalize "${origin_dir}/Projects/400G/vivado_proj_2023.1/400G_sim/fourhundred_gbe/kutleng_skarab2_bsp_firmware/casperbsp/sources/vhdl/rtl/ringbuffer/cpuifsenderpacketringbuffer.vhd"] \
 [file normalize "${origin_dir}/Projects/400G/vivado_proj_2023.1/400G_sim/fourhundred_gbe/kutleng_skarab2_bsp_firmware/casperbsp/sources/vhdl/rtl/udp/macinterface/cpuinterface/cpumacifethernetreceiver400g.vhd"] \
 [file normalize "${origin_dir}/Projects/400G/vivado_proj_2023.1/400G_sim/fourhundred_gbe/kutleng_skarab2_bsp_firmware/casperbsp/sources/vhdl/rtl/udp/macinterface/cpuinterface/cpumacifudpreceiver400g.vhd"] \
 [file normalize "${origin_dir}/Projects/400G/vivado_proj_2023.1/400G_sim/fourhundred_gbe/kutleng_skarab2_bsp_firmware/casperbsp/sources/vhdl/rtl/udp/macinterface/cpuinterface/cpumacifudpsender400g.vhd"] \
 [file normalize "${origin_dir}/Projects/400G/vivado_proj_2023.1/400G_sim/fourhundred_gbe/kutleng_skarab2_bsp_firmware/casperbsp/sources/vhdl/rtl/ringbuffer/dualportpacketringbuffer.vhd"] \
 [file normalize "${origin_dir}/Projects/400G/vivado_proj_2023.1/400G_sim/fourhundred_gbe/kutleng_skarab2_bsp_firmware/casperbsp/sources/vhdl/rtl/lbustoaxis/lbustxaxisrx400g.vhd"] \
 [file normalize "${origin_dir}/Projects/400G/vivado_proj_2023.1/400G_sim/fourhundred_gbe/kutleng_skarab2_bsp_firmware/casperbsp/sources/vhdl/rtl/macphy/mac400gphy.vhd"] \
 [file normalize "${origin_dir}/Projects/400G/vivado_proj_2023.1/400G_sim/fourhundred_gbe/kutleng_skarab2_bsp_firmware/casperbsp/sources/vhdl/rtl/macphy/macaxisdecoupler400g.vhd"] \
 [file normalize "${origin_dir}/Projects/400G/vivado_proj_2023.1/400G_sim/fourhundred_gbe/kutleng_skarab2_bsp_firmware/casperbsp/sources/vhdl/rtl/macphy/macaxisreceiver400g.vhd"] \
 [file normalize "${origin_dir}/Projects/400G/vivado_proj_2023.1/400G_sim/fourhundred_gbe/kutleng_skarab2_bsp_firmware/casperbsp/sources/vhdl/rtl/macphy/macaxissender400g.vhd"] \
 [file normalize "${origin_dir}/Projects/400G/vivado_proj_2023.1/400G_sim/fourhundred_gbe/kutleng_skarab2_bsp_firmware/casperbsp/sources/vhdl/rtl/udp/macinterface/macifudpreceiver400g.vhd"] \
 [file normalize "${origin_dir}/Projects/400G/vivado_proj_2023.1/400G_sim/fourhundred_gbe/kutleng_skarab2_bsp_firmware/casperbsp/sources/vhdl/rtl/udp/macinterface/macifudpsender400g.vhd"] \
 [file normalize "${origin_dir}/Projects/400G/vivado_proj_2023.1/400G_sim/fourhundred_gbe/kutleng_skarab2_bsp_firmware/casperbsp/sources/vhdl/rtl/udp/macinterface/macifudpserver400g.vhd"] \
 [file normalize "${origin_dir}/Projects/400G/vivado_proj_2023.1/400G_sim/fourhundred_gbe/kutleng_skarab2_bsp_firmware/casperbsp/sources/vhdl/rtl/lbustoaxis/mapaxisdatatolbus400g.vhd"] \
 [file normalize "${origin_dir}/Projects/400G/vivado_proj_2023.1/400G_sim/fourhundred_gbe/kutleng_skarab2_bsp_firmware/casperbsp/sources/vhdl/rtl/lbustoaxis/maptkeeptomty.vhd"] \
 [file normalize "${origin_dir}/Projects/400G/vivado_proj_2023.1/400G_sim/fourhundred_gbe/kutleng_skarab2_bsp_firmware/casperbsp/sources/vhdl/rtl/ringbuffer/packetramdp.vhd"] \
 [file normalize "${origin_dir}/Projects/400G/vivado_proj_2023.1/400G_sim/fourhundred_gbe/kutleng_skarab2_bsp_firmware/casperbsp/sources/vhdl/rtl/ringbuffer/packetramsp.vhd"] \
 [file normalize "${origin_dir}/Projects/400G/vivado_proj_2023.1/400G_sim/fourhundred_gbe/kutleng_skarab2_bsp_firmware/casperbsp/sources/vhdl/rtl/ringbuffer/packetringbuffer.vhd"] \
 [file normalize "${origin_dir}/Projects/400G/vivado_proj_2023.1/400G_sim/fourhundred_gbe/kutleng_skarab2_bsp_firmware/casperbsp/sources/vhdl/rtl/ringbuffer/packetstatusram.vhd"] \
 [file normalize "${origin_dir}/Projects/400G/vivado_proj_2023.1/400G_sim/fourhundred_gbe/kutleng_skarab2_bsp_firmware/casperbsp/sources/vhdl/rtl/arp/ramdpwr.vhd"] \
 [file normalize "${origin_dir}/Projects/400G/vivado_proj_2023.1/400G_sim/fourhundred_gbe/kutleng_skarab2_bsp_firmware/casperbsp/sources/vhdl/rtl/arp/ramdpwrr.vhd"] \
 [file normalize "${origin_dir}/Projects/400G/vivado_proj_2023.1/400G_sim/fourhundred_gbe/kutleng_skarab2_bsp_firmware/casperbsp/sources/vhdl/rtl/ringbuffer/truedualportpacketringbuffer.vhd"] \
 [file normalize "${origin_dir}/Projects/400G/vivado_proj_2023.1/400G_sim/fourhundred_gbe/kutleng_skarab2_bsp_firmware/casperbsp/sources/vhdl/rtl/udp/udpdatapacker400g.vhd"] \
 [file normalize "${origin_dir}/Projects/400G/vivado_proj_2023.1/400G_sim/fourhundred_gbe/kutleng_skarab2_bsp_firmware/casperbsp/sources/vhdl/rtl/udp/udpdatastripper400g.vhd"] \
 [file normalize "${origin_dir}/Projects/400G/vivado_proj_2023.1/400G_sim/fourhundred_gbe/kutleng_skarab2_bsp_firmware/casperbsp/sources/vhdl/rtl/udp/udpipinterfacepr400g.vhd"] \
 [file normalize "${origin_dir}/Projects/400G/vivado_proj_2023.1/400G_sim/fourhundred_gbe/kutleng_skarab2_bsp_firmware/casperbsp/sources/vhdl/rtl/udp/udpstreamingapp400g.vhd"] \
 [file normalize "${origin_dir}/Projects/400G/vivado_proj_2023.1/400G_sim/fourhundred_gbe/kutleng_skarab2_bsp_firmware/casperbsp/sources/vhdl/rtl/udp/udpstreamingapps400g.vhd"] \
 [file normalize "${origin_dir}/Projects/400G/vivado_proj_2023.1/400G_sim/fourhundred_gbe/dcmac_udp_demo.v"] \
 [file normalize "${origin_dir}/Projects/400G/vivado_proj_2023.1/400G_sim/fourhundred_gbe/kutleng_skarab2_bsp_firmware/casperbsp/sources/vhdl/rtl/lbustoaxis/mapaxisdatatolbus.vhd"] \
 [file normalize "${origin_dir}/Projects/400G/vivado_proj_2023.1/400G_sim/fourhundred_gbe/fhg_axis_adapter.v"] \
 [file normalize "${origin_dir}/Projects/400G/vivado_proj_2023.1/400G_sim/fourhundred_gbe/kutleng_skarab2_bsp_firmware/casperbsp/sources/vhdl/rtl/arp/arpmodule.vhd"] \
 [file normalize "${origin_dir}/Projects/400G/vivado_proj_2023.1/400G_sim/fourhundred_gbe/kutleng_skarab2_bsp_firmware/casperbsp/sources/vhdl/rtl/arp/arpreceiver.vhd"] \
 [file normalize "${origin_dir}/Projects/400G/vivado_proj_2023.1/400G_sim/fourhundred_gbe/kutleng_skarab2_bsp_firmware/casperbsp/sources/vhdl/rtl/lbustoaxis/mapmtytotkeep.vhd"] \
 [file normalize "${origin_dir}/Projects/400G/vivado_proj_2023.1/400G_sim/fourhundred_gbe/delay.v"] \
 [file normalize "${origin_dir}/Projects/400G/vivado_proj_2023.1/400G_sim/fourhundred_gbe/addr_shift.v"] \
]
add_files -norecurse -fileset $obj $files

# Proc to create BD axispacketbufferfifo400g
proc cr_bd_axispacketbufferfifo400g { parentCell } {

  # CHANGE DESIGN NAME HERE
  set design_name axispacketbufferfifo400g

  common::send_gid_msg -ssname BD::TCL -id 2010 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

  create_bd_design $design_name

  set bCheckIPsPassed 1
  ##################################################################
  # CHECK IPs
  ##################################################################
  set bCheckIPs 1
  if { $bCheckIPs == 1 } {
     set list_check_ips "\ 
  xilinx.com:ip:axis_data_fifo:2.0\
  "

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

  }

  if { $bCheckIPsPassed != 1 } {
    common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
    return 3
  }

  variable script_folder

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports

  # Create ports
  set s_aresetn [ create_bd_port -dir I -type rst s_aresetn ]
  set s_aclk [ create_bd_port -dir I -type clk s_aclk ]
  set s_axis_tdata [ create_bd_port -dir I -from 1023 -to 0 s_axis_tdata ]
  set s_axis_tkeep [ create_bd_port -dir I -from 127 -to 0 s_axis_tkeep ]
  set s_axis_tlast [ create_bd_port -dir I s_axis_tlast ]
  set s_axis_tready [ create_bd_port -dir O s_axis_tready ]
  set s_axis_tuser [ create_bd_port -dir I -from 0 -to 0 s_axis_tuser ]
  set s_axis_tvalid [ create_bd_port -dir I s_axis_tvalid ]
  set m_axis_tlast [ create_bd_port -dir O m_axis_tlast ]
  set m_axis_tready [ create_bd_port -dir I m_axis_tready ]
  set m_axis_tuser [ create_bd_port -dir O -from 0 -to 0 m_axis_tuser ]
  set m_axis_tvalid [ create_bd_port -dir O m_axis_tvalid ]
  set m_axis_tdata [ create_bd_port -dir O -from 1023 -to 0 m_axis_tdata ]
  set m_axis_tkeep [ create_bd_port -dir O -from 127 -to 0 m_axis_tkeep ]
  set axis_prog_full [ create_bd_port -dir O axis_prog_full ]

  # Create instance: axis_data_fifo_0, and set properties
  set axis_data_fifo_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_0 ]
  set_property -dict [list \
    CONFIG.FIFO_DEPTH {128} \
    CONFIG.HAS_PROG_FULL {1} \
    CONFIG.HAS_TKEEP {1} \
    CONFIG.HAS_TLAST {1} \
    CONFIG.TDATA_NUM_BYTES {128} \
    CONFIG.TUSER_WIDTH {1} \
  ] $axis_data_fifo_0


  # Create port connections
  connect_bd_net -net axis_data_fifo_0_m_axis_tdata [get_bd_pins axis_data_fifo_0/m_axis_tdata] [get_bd_ports m_axis_tdata]
  connect_bd_net -net axis_data_fifo_0_m_axis_tkeep [get_bd_pins axis_data_fifo_0/m_axis_tkeep] [get_bd_ports m_axis_tkeep]
  connect_bd_net -net axis_data_fifo_0_m_axis_tlast [get_bd_pins axis_data_fifo_0/m_axis_tlast] [get_bd_ports m_axis_tlast]
  connect_bd_net -net axis_data_fifo_0_m_axis_tuser [get_bd_pins axis_data_fifo_0/m_axis_tuser] [get_bd_ports m_axis_tuser]
  connect_bd_net -net axis_data_fifo_0_m_axis_tvalid [get_bd_pins axis_data_fifo_0/m_axis_tvalid] [get_bd_ports m_axis_tvalid]
  connect_bd_net -net axis_data_fifo_0_prog_full [get_bd_pins axis_data_fifo_0/prog_full] [get_bd_ports axis_prog_full]
  connect_bd_net -net axis_data_fifo_0_s_axis_tready [get_bd_pins axis_data_fifo_0/s_axis_tready] [get_bd_ports s_axis_tready]
  connect_bd_net -net m_axis_tready_0_1 [get_bd_ports m_axis_tready] [get_bd_pins axis_data_fifo_0/m_axis_tready]
  connect_bd_net -net s_axis_aclk_0_1 [get_bd_ports s_aclk] [get_bd_pins axis_data_fifo_0/s_axis_aclk]
  connect_bd_net -net s_axis_aresetn_0_1 [get_bd_ports s_aresetn] [get_bd_pins axis_data_fifo_0/s_axis_aresetn]
  connect_bd_net -net s_axis_tdata_0_1 [get_bd_ports s_axis_tdata] [get_bd_pins axis_data_fifo_0/s_axis_tdata]
  connect_bd_net -net s_axis_tkeep_0_1 [get_bd_ports s_axis_tkeep] [get_bd_pins axis_data_fifo_0/s_axis_tkeep]
  connect_bd_net -net s_axis_tlast_0_1 [get_bd_ports s_axis_tlast] [get_bd_pins axis_data_fifo_0/s_axis_tlast]
  connect_bd_net -net s_axis_tuser_0_1 [get_bd_ports s_axis_tuser] [get_bd_pins axis_data_fifo_0/s_axis_tuser]
  connect_bd_net -net s_axis_tvalid_0_1 [get_bd_ports s_axis_tvalid] [get_bd_pins axis_data_fifo_0/s_axis_tvalid]

  # Create address segments


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
  close_bd_design $design_name 
}
# End of cr_bd_axispacketbufferfifo400g()
cr_bd_axispacketbufferfifo400g ""
set_property REGISTERED_WITH_MANAGER "1" [get_files axispacketbufferfifo400g.bd ] 
set_property SYNTH_CHECKPOINT_MODE "Hierarchical" [get_files axispacketbufferfifo400g.bd ] 

# Proc to create BD dest_address_fifo_400g
proc cr_bd_dest_address_fifo_400g { parentCell } {

  # CHANGE DESIGN NAME HERE
  set design_name dest_address_fifo_400g

  common::send_gid_msg -ssname BD::TCL -id 2010 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

  create_bd_design $design_name

  set bCheckIPsPassed 1
  ##################################################################
  # CHECK IPs
  ##################################################################
  set bCheckIPs 1
  if { $bCheckIPs == 1 } {
     set list_check_ips "\ 
  xilinx.com:ip:emb_fifo_gen:1.0\
  "

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

  }

  if { $bCheckIPsPassed != 1 } {
    common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
    return 3
  }

  variable script_folder

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports

  # Create ports
  set din [ create_bd_port -dir I -from 47 -to 0 din ]
  set dout [ create_bd_port -dir O -from 47 -to 0 dout ]
  set empty [ create_bd_port -dir O empty ]
  set full [ create_bd_port -dir O full ]
  set rd_clk [ create_bd_port -dir I -type clk rd_clk ]
  set rd_en [ create_bd_port -dir I rd_en ]
  set rd_rst_busy [ create_bd_port -dir O rd_rst_busy ]
  set rst [ create_bd_port -dir I rst ]
  set wr_clk [ create_bd_port -dir I -type clk wr_clk ]
  set wr_en [ create_bd_port -dir I wr_en ]
  set wr_rst_busy [ create_bd_port -dir O wr_rst_busy ]

  # Create instance: emb_fifo_gen_0, and set properties
  set emb_fifo_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:emb_fifo_gen:1.0 emb_fifo_gen_0 ]
  set_property -dict [list \
    CONFIG.CLOCK_DOMAIN {Independent_Clock} \
    CONFIG.ENABLE_ALMOST_EMPTY {false} \
    CONFIG.ENABLE_ALMOST_FULL {false} \
    CONFIG.ENABLE_DATA_COUNT {false} \
    CONFIG.ENABLE_OVERFLOW {false} \
    CONFIG.ENABLE_PROGRAMMABLE_EMPTY {false} \
    CONFIG.ENABLE_PROGRAMMABLE_FULL {false} \
    CONFIG.ENABLE_READ_DATA_COUNT {false} \
    CONFIG.ENABLE_READ_DATA_VALID {false} \
    CONFIG.ENABLE_UNDERFLOW {false} \
    CONFIG.ENABLE_WRITE_ACK {false} \
    CONFIG.ENABLE_WRITE_DATA_COUNT {false} \
    CONFIG.FIFO_WRITE_DEPTH {16} \
    CONFIG.READ_MODE {FWFT} \
    CONFIG.WRITE_DATA_WIDTH {48} \
  ] $emb_fifo_gen_0


  # Create port connections
  connect_bd_net -net din_0_1 [get_bd_ports din] [get_bd_pins emb_fifo_gen_0/din]
  connect_bd_net -net emb_fifo_gen_0_dout [get_bd_pins emb_fifo_gen_0/dout] [get_bd_ports dout]
  connect_bd_net -net emb_fifo_gen_0_empty [get_bd_pins emb_fifo_gen_0/empty] [get_bd_ports empty]
  connect_bd_net -net emb_fifo_gen_0_full [get_bd_pins emb_fifo_gen_0/full] [get_bd_ports full]
  connect_bd_net -net emb_fifo_gen_0_rd_rst_busy [get_bd_pins emb_fifo_gen_0/rd_rst_busy] [get_bd_ports rd_rst_busy]
  connect_bd_net -net emb_fifo_gen_0_wr_rst_busy [get_bd_pins emb_fifo_gen_0/wr_rst_busy] [get_bd_ports wr_rst_busy]
  connect_bd_net -net rd_clk_0_1 [get_bd_ports rd_clk] [get_bd_pins emb_fifo_gen_0/rd_clk]
  connect_bd_net -net rd_en_0_1 [get_bd_ports rd_en] [get_bd_pins emb_fifo_gen_0/rd_en]
  connect_bd_net -net rst_0_1 [get_bd_ports rst] [get_bd_pins emb_fifo_gen_0/rst]
  connect_bd_net -net wr_clk_0_1 [get_bd_ports wr_clk] [get_bd_pins emb_fifo_gen_0/wr_clk]
  connect_bd_net -net wr_en_0_1 [get_bd_ports wr_en] [get_bd_pins emb_fifo_gen_0/wr_en]

  # Create address segments


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
  close_bd_design $design_name 
}
# End of cr_bd_dest_address_fifo_400g()
cr_bd_dest_address_fifo_400g ""
set_property REGISTERED_WITH_MANAGER "1" [get_files dest_address_fifo_400g.bd ] 
set_property SYNTH_CHECKPOINT_MODE "Hierarchical" [get_files dest_address_fifo_400g.bd ] 

