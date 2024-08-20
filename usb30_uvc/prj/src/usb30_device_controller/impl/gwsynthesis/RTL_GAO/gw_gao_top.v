module gw_gao(
    \usb30_device_controller_top_inst/ltssm_state[4] ,
    \usb30_device_controller_top_inst/ltssm_state[3] ,
    \usb30_device_controller_top_inst/ltssm_state[2] ,
    \usb30_device_controller_top_inst/ltssm_state[1] ,
    \usb30_device_controller_top_inst/ltssm_state[0] ,
    \usb30_device_controller_top_inst/iu3l/in_data[31] ,
    \usb30_device_controller_top_inst/iu3l/in_data[30] ,
    \usb30_device_controller_top_inst/iu3l/in_data[29] ,
    \usb30_device_controller_top_inst/iu3l/in_data[28] ,
    \usb30_device_controller_top_inst/iu3l/in_data[27] ,
    \usb30_device_controller_top_inst/iu3l/in_data[26] ,
    \usb30_device_controller_top_inst/iu3l/in_data[25] ,
    \usb30_device_controller_top_inst/iu3l/in_data[24] ,
    \usb30_device_controller_top_inst/iu3l/in_data[23] ,
    \usb30_device_controller_top_inst/iu3l/in_data[22] ,
    \usb30_device_controller_top_inst/iu3l/in_data[21] ,
    \usb30_device_controller_top_inst/iu3l/in_data[20] ,
    \usb30_device_controller_top_inst/iu3l/in_data[19] ,
    \usb30_device_controller_top_inst/iu3l/in_data[18] ,
    \usb30_device_controller_top_inst/iu3l/in_data[17] ,
    \usb30_device_controller_top_inst/iu3l/in_data[16] ,
    \usb30_device_controller_top_inst/iu3l/in_data[15] ,
    \usb30_device_controller_top_inst/iu3l/in_data[14] ,
    \usb30_device_controller_top_inst/iu3l/in_data[13] ,
    \usb30_device_controller_top_inst/iu3l/in_data[12] ,
    \usb30_device_controller_top_inst/iu3l/in_data[11] ,
    \usb30_device_controller_top_inst/iu3l/in_data[10] ,
    \usb30_device_controller_top_inst/iu3l/in_data[9] ,
    \usb30_device_controller_top_inst/iu3l/in_data[8] ,
    \usb30_device_controller_top_inst/iu3l/in_data[7] ,
    \usb30_device_controller_top_inst/iu3l/in_data[6] ,
    \usb30_device_controller_top_inst/iu3l/in_data[5] ,
    \usb30_device_controller_top_inst/iu3l/in_data[4] ,
    \usb30_device_controller_top_inst/iu3l/in_data[3] ,
    \usb30_device_controller_top_inst/iu3l/in_data[2] ,
    \usb30_device_controller_top_inst/iu3l/in_data[1] ,
    \usb30_device_controller_top_inst/iu3l/in_data[0] ,
    \usb30_device_controller_top_inst/iu3l/in_datak[3] ,
    \usb30_device_controller_top_inst/iu3l/in_datak[2] ,
    \usb30_device_controller_top_inst/iu3l/in_datak[1] ,
    \usb30_device_controller_top_inst/iu3l/in_datak[0] ,
    \usb30_device_controller_top_inst/iu3l/in_active ,
    \usb30_device_controller_top_inst/iu3l/outp_data[31] ,
    \usb30_device_controller_top_inst/iu3l/outp_data[30] ,
    \usb30_device_controller_top_inst/iu3l/outp_data[29] ,
    \usb30_device_controller_top_inst/iu3l/outp_data[28] ,
    \usb30_device_controller_top_inst/iu3l/outp_data[27] ,
    \usb30_device_controller_top_inst/iu3l/outp_data[26] ,
    \usb30_device_controller_top_inst/iu3l/outp_data[25] ,
    \usb30_device_controller_top_inst/iu3l/outp_data[24] ,
    \usb30_device_controller_top_inst/iu3l/outp_data[23] ,
    \usb30_device_controller_top_inst/iu3l/outp_data[22] ,
    \usb30_device_controller_top_inst/iu3l/outp_data[21] ,
    \usb30_device_controller_top_inst/iu3l/outp_data[20] ,
    \usb30_device_controller_top_inst/iu3l/outp_data[19] ,
    \usb30_device_controller_top_inst/iu3l/outp_data[18] ,
    \usb30_device_controller_top_inst/iu3l/outp_data[17] ,
    \usb30_device_controller_top_inst/iu3l/outp_data[16] ,
    \usb30_device_controller_top_inst/iu3l/outp_data[15] ,
    \usb30_device_controller_top_inst/iu3l/outp_data[14] ,
    \usb30_device_controller_top_inst/iu3l/outp_data[13] ,
    \usb30_device_controller_top_inst/iu3l/outp_data[12] ,
    \usb30_device_controller_top_inst/iu3l/outp_data[11] ,
    \usb30_device_controller_top_inst/iu3l/outp_data[10] ,
    \usb30_device_controller_top_inst/iu3l/outp_data[9] ,
    \usb30_device_controller_top_inst/iu3l/outp_data[8] ,
    \usb30_device_controller_top_inst/iu3l/outp_data[7] ,
    \usb30_device_controller_top_inst/iu3l/outp_data[6] ,
    \usb30_device_controller_top_inst/iu3l/outp_data[5] ,
    \usb30_device_controller_top_inst/iu3l/outp_data[4] ,
    \usb30_device_controller_top_inst/iu3l/outp_data[3] ,
    \usb30_device_controller_top_inst/iu3l/outp_data[2] ,
    \usb30_device_controller_top_inst/iu3l/outp_data[1] ,
    \usb30_device_controller_top_inst/iu3l/outp_data[0] ,
    \usb30_device_controller_top_inst/iu3l/outp_datak[3] ,
    \usb30_device_controller_top_inst/iu3l/outp_datak[2] ,
    \usb30_device_controller_top_inst/iu3l/outp_datak[1] ,
    \usb30_device_controller_top_inst/iu3l/outp_datak[0] ,
    \usb30_device_controller_top_inst/iu3l/outp_active ,
    \usb30_device_controller_top_inst/iu3l/ltssm_go_recovery ,
    \usb30_device_controller_top_inst/iu3l/err_hp_seq ,
    \usb30_device_controller_top_inst/iu3l/err_lgood_order ,
    \usb30_device_controller_top_inst/iu3l/err_lcrd_mismatch ,
    \usb30_device_controller_top_inst/iu3l/tx_hdr_seq_num[2] ,
    \usb30_device_controller_top_inst/iu3l/tx_hdr_seq_num[1] ,
    \usb30_device_controller_top_inst/iu3l/tx_hdr_seq_num[0] ,
    \usb30_device_controller_top_inst/iu3l/rx_hdr_seq_num[2] ,
    \usb30_device_controller_top_inst/iu3l/rx_hdr_seq_num[1] ,
    \usb30_device_controller_top_inst/iu3l/rx_hdr_seq_num[0] ,
    \usb30_device_controller_top_inst/iu3l/ack_tx_hdr_seq_num[2] ,
    \usb30_device_controller_top_inst/iu3l/ack_tx_hdr_seq_num[1] ,
    \usb30_device_controller_top_inst/iu3l/ack_tx_hdr_seq_num[0] ,
    \usb30_device_controller_top_inst/iu3l/tx_cred_idx[1] ,
    \usb30_device_controller_top_inst/iu3l/tx_cred_idx[0] ,
    \usb30_device_controller_top_inst/iu3l/enter_u0_cnt[7] ,
    \usb30_device_controller_top_inst/iu3l/enter_u0_cnt[6] ,
    \usb30_device_controller_top_inst/iu3l/enter_u0_cnt[5] ,
    \usb30_device_controller_top_inst/iu3l/enter_u0_cnt[4] ,
    \usb30_device_controller_top_inst/iu3l/enter_u0_cnt[3] ,
    \usb30_device_controller_top_inst/iu3l/enter_u0_cnt[2] ,
    \usb30_device_controller_top_inst/iu3l/enter_u0_cnt[1] ,
    \usb30_device_controller_top_inst/iu3l/enter_u0_cnt[0] ,
    \usb30_device_controller_top_inst/iu3l/in_active_too_many_low ,
    \usb30_device_controller_top_inst/iu3r/iu3ep0/req_cnt[7] ,
    \usb30_device_controller_top_inst/iu3r/iu3ep0/req_cnt[6] ,
    \usb30_device_controller_top_inst/iu3r/iu3ep0/req_cnt[5] ,
    \usb30_device_controller_top_inst/iu3r/iu3ep0/req_cnt[4] ,
    \usb30_device_controller_top_inst/iu3r/iu3ep0/req_cnt[3] ,
    \usb30_device_controller_top_inst/iu3r/iu3ep0/req_cnt[2] ,
    \usb30_device_controller_top_inst/iu3r/iu3ep0/req_cnt[1] ,
    \usb30_device_controller_top_inst/iu3r/iu3ep0/req_cnt[0] ,
    \UserLayer_top_inst/ControlTransfer_inst/request_active ,
    \UserLayer_top_inst/ControlTransfer_inst/bmRequestType[7] ,
    \UserLayer_top_inst/ControlTransfer_inst/bmRequestType[6] ,
    \UserLayer_top_inst/ControlTransfer_inst/bmRequestType[5] ,
    \UserLayer_top_inst/ControlTransfer_inst/bmRequestType[4] ,
    \UserLayer_top_inst/ControlTransfer_inst/bmRequestType[3] ,
    \UserLayer_top_inst/ControlTransfer_inst/bmRequestType[2] ,
    \UserLayer_top_inst/ControlTransfer_inst/bmRequestType[1] ,
    \UserLayer_top_inst/ControlTransfer_inst/bmRequestType[0] ,
    \UserLayer_top_inst/ControlTransfer_inst/bRequest[7] ,
    \UserLayer_top_inst/ControlTransfer_inst/bRequest[6] ,
    \UserLayer_top_inst/ControlTransfer_inst/bRequest[5] ,
    \UserLayer_top_inst/ControlTransfer_inst/bRequest[4] ,
    \UserLayer_top_inst/ControlTransfer_inst/bRequest[3] ,
    \UserLayer_top_inst/ControlTransfer_inst/bRequest[2] ,
    \UserLayer_top_inst/ControlTransfer_inst/bRequest[1] ,
    \UserLayer_top_inst/ControlTransfer_inst/bRequest[0] ,
    \UserLayer_top_inst/ControlTransfer_inst/wValue[15] ,
    \UserLayer_top_inst/ControlTransfer_inst/wValue[14] ,
    \UserLayer_top_inst/ControlTransfer_inst/wValue[13] ,
    \UserLayer_top_inst/ControlTransfer_inst/wValue[12] ,
    \UserLayer_top_inst/ControlTransfer_inst/wValue[11] ,
    \UserLayer_top_inst/ControlTransfer_inst/wValue[10] ,
    \UserLayer_top_inst/ControlTransfer_inst/wValue[9] ,
    \UserLayer_top_inst/ControlTransfer_inst/wValue[8] ,
    \UserLayer_top_inst/ControlTransfer_inst/wValue[7] ,
    \UserLayer_top_inst/ControlTransfer_inst/wValue[6] ,
    \UserLayer_top_inst/ControlTransfer_inst/wValue[5] ,
    \UserLayer_top_inst/ControlTransfer_inst/wValue[4] ,
    \UserLayer_top_inst/ControlTransfer_inst/wValue[3] ,
    \UserLayer_top_inst/ControlTransfer_inst/wValue[2] ,
    \UserLayer_top_inst/ControlTransfer_inst/wValue[1] ,
    \UserLayer_top_inst/ControlTransfer_inst/wValue[0] ,
    \UserLayer_top_inst/ControlTransfer_inst/wIndex[15] ,
    \UserLayer_top_inst/ControlTransfer_inst/wIndex[14] ,
    \UserLayer_top_inst/ControlTransfer_inst/wIndex[13] ,
    \UserLayer_top_inst/ControlTransfer_inst/wIndex[12] ,
    \UserLayer_top_inst/ControlTransfer_inst/wIndex[11] ,
    \UserLayer_top_inst/ControlTransfer_inst/wIndex[10] ,
    \UserLayer_top_inst/ControlTransfer_inst/wIndex[9] ,
    \UserLayer_top_inst/ControlTransfer_inst/wIndex[8] ,
    \UserLayer_top_inst/ControlTransfer_inst/wIndex[7] ,
    \UserLayer_top_inst/ControlTransfer_inst/wIndex[6] ,
    \UserLayer_top_inst/ControlTransfer_inst/wIndex[5] ,
    \UserLayer_top_inst/ControlTransfer_inst/wIndex[4] ,
    \UserLayer_top_inst/ControlTransfer_inst/wIndex[3] ,
    \UserLayer_top_inst/ControlTransfer_inst/wIndex[2] ,
    \UserLayer_top_inst/ControlTransfer_inst/wIndex[1] ,
    \UserLayer_top_inst/ControlTransfer_inst/wIndex[0] ,
    \UserLayer_top_inst/ControlTransfer_inst/wLength[15] ,
    \UserLayer_top_inst/ControlTransfer_inst/wLength[14] ,
    \UserLayer_top_inst/ControlTransfer_inst/wLength[13] ,
    \UserLayer_top_inst/ControlTransfer_inst/wLength[12] ,
    \UserLayer_top_inst/ControlTransfer_inst/wLength[11] ,
    \UserLayer_top_inst/ControlTransfer_inst/wLength[10] ,
    \UserLayer_top_inst/ControlTransfer_inst/wLength[9] ,
    \UserLayer_top_inst/ControlTransfer_inst/wLength[8] ,
    \UserLayer_top_inst/ControlTransfer_inst/wLength[7] ,
    \UserLayer_top_inst/ControlTransfer_inst/wLength[6] ,
    \UserLayer_top_inst/ControlTransfer_inst/wLength[5] ,
    \UserLayer_top_inst/ControlTransfer_inst/wLength[4] ,
    \UserLayer_top_inst/ControlTransfer_inst/wLength[3] ,
    \UserLayer_top_inst/ControlTransfer_inst/wLength[2] ,
    \UserLayer_top_inst/ControlTransfer_inst/wLength[1] ,
    \UserLayer_top_inst/ControlTransfer_inst/wLength[0] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[31] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[30] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[29] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[28] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[27] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[26] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[25] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[24] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[23] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[22] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[21] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[20] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[19] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[18] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[17] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[16] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[15] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[14] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[13] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[12] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[11] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[10] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[9] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[8] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[7] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[6] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[5] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[4] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[3] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[2] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[1] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[0] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_wren ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_ready ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_commit ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_commit_len[10] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_commit_len[9] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_commit_len[8] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_commit_len[7] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_commit_len[6] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_commit_len[5] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_commit_len[4] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_commit_len[3] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_commit_len[2] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_commit_len[1] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_commit_len[0] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[31] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[30] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[29] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[28] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[27] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[26] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[25] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[24] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[23] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[22] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[21] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[20] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[19] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[18] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[17] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[16] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[15] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[14] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[13] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[12] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[11] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[10] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[9] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[8] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[7] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[6] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[5] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[4] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[3] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[2] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[1] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[0] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_len[10] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_len[9] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_len[8] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_len[7] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_len[6] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_len[5] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_len[4] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_len[3] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_len[2] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_len[1] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_len[0] ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_hasdata ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_rden ,
    \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_ack ,
    \usb30_device_controller_top_inst/iu3lt/dc[25] ,
    \usb30_device_controller_top_inst/iu3lt/dc[24] ,
    \usb30_device_controller_top_inst/iu3lt/dc[23] ,
    \usb30_device_controller_top_inst/iu3lt/dc[22] ,
    \usb30_device_controller_top_inst/iu3lt/dc[21] ,
    \usb30_device_controller_top_inst/iu3lt/dc[20] ,
    \usb30_device_controller_top_inst/iu3lt/dc[19] ,
    \usb30_device_controller_top_inst/iu3lt/dc[18] ,
    \usb30_device_controller_top_inst/iu3lt/dc[17] ,
    \usb30_device_controller_top_inst/iu3lt/dc[16] ,
    \usb30_device_controller_top_inst/iu3lt/dc[15] ,
    \usb30_device_controller_top_inst/iu3lt/dc[14] ,
    \usb30_device_controller_top_inst/iu3lt/dc[13] ,
    \usb30_device_controller_top_inst/iu3lt/dc[12] ,
    \usb30_device_controller_top_inst/iu3lt/dc[11] ,
    \usb30_device_controller_top_inst/iu3lt/dc[10] ,
    \usb30_device_controller_top_inst/iu3lt/dc[9] ,
    \usb30_device_controller_top_inst/iu3lt/dc[8] ,
    \usb30_device_controller_top_inst/iu3lt/dc[7] ,
    \usb30_device_controller_top_inst/iu3lt/dc[6] ,
    \usb30_device_controller_top_inst/iu3lt/dc[5] ,
    \usb30_device_controller_top_inst/iu3lt/dc[4] ,
    \usb30_device_controller_top_inst/iu3lt/dc[3] ,
    \usb30_device_controller_top_inst/iu3lt/dc[2] ,
    \usb30_device_controller_top_inst/iu3lt/dc[1] ,
    \usb30_device_controller_top_inst/iu3lt/dc[0] ,
    \usb30_device_controller_top_inst/iu3lt/partner_looking ,
    \usb30_device_controller_top_inst/iu3lt/partner_detect ,
    \usb30_device_controller_top_inst/iu3lt/partner_detected ,
    \usb30_device_controller_top_inst/iu3lt/u3_detect ,
    pclk,
    tms_pad_i,
    tck_pad_i,
    tdi_pad_i,
    tdo_pad_o
);

input \usb30_device_controller_top_inst/ltssm_state[4] ;
input \usb30_device_controller_top_inst/ltssm_state[3] ;
input \usb30_device_controller_top_inst/ltssm_state[2] ;
input \usb30_device_controller_top_inst/ltssm_state[1] ;
input \usb30_device_controller_top_inst/ltssm_state[0] ;
input \usb30_device_controller_top_inst/iu3l/in_data[31] ;
input \usb30_device_controller_top_inst/iu3l/in_data[30] ;
input \usb30_device_controller_top_inst/iu3l/in_data[29] ;
input \usb30_device_controller_top_inst/iu3l/in_data[28] ;
input \usb30_device_controller_top_inst/iu3l/in_data[27] ;
input \usb30_device_controller_top_inst/iu3l/in_data[26] ;
input \usb30_device_controller_top_inst/iu3l/in_data[25] ;
input \usb30_device_controller_top_inst/iu3l/in_data[24] ;
input \usb30_device_controller_top_inst/iu3l/in_data[23] ;
input \usb30_device_controller_top_inst/iu3l/in_data[22] ;
input \usb30_device_controller_top_inst/iu3l/in_data[21] ;
input \usb30_device_controller_top_inst/iu3l/in_data[20] ;
input \usb30_device_controller_top_inst/iu3l/in_data[19] ;
input \usb30_device_controller_top_inst/iu3l/in_data[18] ;
input \usb30_device_controller_top_inst/iu3l/in_data[17] ;
input \usb30_device_controller_top_inst/iu3l/in_data[16] ;
input \usb30_device_controller_top_inst/iu3l/in_data[15] ;
input \usb30_device_controller_top_inst/iu3l/in_data[14] ;
input \usb30_device_controller_top_inst/iu3l/in_data[13] ;
input \usb30_device_controller_top_inst/iu3l/in_data[12] ;
input \usb30_device_controller_top_inst/iu3l/in_data[11] ;
input \usb30_device_controller_top_inst/iu3l/in_data[10] ;
input \usb30_device_controller_top_inst/iu3l/in_data[9] ;
input \usb30_device_controller_top_inst/iu3l/in_data[8] ;
input \usb30_device_controller_top_inst/iu3l/in_data[7] ;
input \usb30_device_controller_top_inst/iu3l/in_data[6] ;
input \usb30_device_controller_top_inst/iu3l/in_data[5] ;
input \usb30_device_controller_top_inst/iu3l/in_data[4] ;
input \usb30_device_controller_top_inst/iu3l/in_data[3] ;
input \usb30_device_controller_top_inst/iu3l/in_data[2] ;
input \usb30_device_controller_top_inst/iu3l/in_data[1] ;
input \usb30_device_controller_top_inst/iu3l/in_data[0] ;
input \usb30_device_controller_top_inst/iu3l/in_datak[3] ;
input \usb30_device_controller_top_inst/iu3l/in_datak[2] ;
input \usb30_device_controller_top_inst/iu3l/in_datak[1] ;
input \usb30_device_controller_top_inst/iu3l/in_datak[0] ;
input \usb30_device_controller_top_inst/iu3l/in_active ;
input \usb30_device_controller_top_inst/iu3l/outp_data[31] ;
input \usb30_device_controller_top_inst/iu3l/outp_data[30] ;
input \usb30_device_controller_top_inst/iu3l/outp_data[29] ;
input \usb30_device_controller_top_inst/iu3l/outp_data[28] ;
input \usb30_device_controller_top_inst/iu3l/outp_data[27] ;
input \usb30_device_controller_top_inst/iu3l/outp_data[26] ;
input \usb30_device_controller_top_inst/iu3l/outp_data[25] ;
input \usb30_device_controller_top_inst/iu3l/outp_data[24] ;
input \usb30_device_controller_top_inst/iu3l/outp_data[23] ;
input \usb30_device_controller_top_inst/iu3l/outp_data[22] ;
input \usb30_device_controller_top_inst/iu3l/outp_data[21] ;
input \usb30_device_controller_top_inst/iu3l/outp_data[20] ;
input \usb30_device_controller_top_inst/iu3l/outp_data[19] ;
input \usb30_device_controller_top_inst/iu3l/outp_data[18] ;
input \usb30_device_controller_top_inst/iu3l/outp_data[17] ;
input \usb30_device_controller_top_inst/iu3l/outp_data[16] ;
input \usb30_device_controller_top_inst/iu3l/outp_data[15] ;
input \usb30_device_controller_top_inst/iu3l/outp_data[14] ;
input \usb30_device_controller_top_inst/iu3l/outp_data[13] ;
input \usb30_device_controller_top_inst/iu3l/outp_data[12] ;
input \usb30_device_controller_top_inst/iu3l/outp_data[11] ;
input \usb30_device_controller_top_inst/iu3l/outp_data[10] ;
input \usb30_device_controller_top_inst/iu3l/outp_data[9] ;
input \usb30_device_controller_top_inst/iu3l/outp_data[8] ;
input \usb30_device_controller_top_inst/iu3l/outp_data[7] ;
input \usb30_device_controller_top_inst/iu3l/outp_data[6] ;
input \usb30_device_controller_top_inst/iu3l/outp_data[5] ;
input \usb30_device_controller_top_inst/iu3l/outp_data[4] ;
input \usb30_device_controller_top_inst/iu3l/outp_data[3] ;
input \usb30_device_controller_top_inst/iu3l/outp_data[2] ;
input \usb30_device_controller_top_inst/iu3l/outp_data[1] ;
input \usb30_device_controller_top_inst/iu3l/outp_data[0] ;
input \usb30_device_controller_top_inst/iu3l/outp_datak[3] ;
input \usb30_device_controller_top_inst/iu3l/outp_datak[2] ;
input \usb30_device_controller_top_inst/iu3l/outp_datak[1] ;
input \usb30_device_controller_top_inst/iu3l/outp_datak[0] ;
input \usb30_device_controller_top_inst/iu3l/outp_active ;
input \usb30_device_controller_top_inst/iu3l/ltssm_go_recovery ;
input \usb30_device_controller_top_inst/iu3l/err_hp_seq ;
input \usb30_device_controller_top_inst/iu3l/err_lgood_order ;
input \usb30_device_controller_top_inst/iu3l/err_lcrd_mismatch ;
input \usb30_device_controller_top_inst/iu3l/tx_hdr_seq_num[2] ;
input \usb30_device_controller_top_inst/iu3l/tx_hdr_seq_num[1] ;
input \usb30_device_controller_top_inst/iu3l/tx_hdr_seq_num[0] ;
input \usb30_device_controller_top_inst/iu3l/rx_hdr_seq_num[2] ;
input \usb30_device_controller_top_inst/iu3l/rx_hdr_seq_num[1] ;
input \usb30_device_controller_top_inst/iu3l/rx_hdr_seq_num[0] ;
input \usb30_device_controller_top_inst/iu3l/ack_tx_hdr_seq_num[2] ;
input \usb30_device_controller_top_inst/iu3l/ack_tx_hdr_seq_num[1] ;
input \usb30_device_controller_top_inst/iu3l/ack_tx_hdr_seq_num[0] ;
input \usb30_device_controller_top_inst/iu3l/tx_cred_idx[1] ;
input \usb30_device_controller_top_inst/iu3l/tx_cred_idx[0] ;
input \usb30_device_controller_top_inst/iu3l/enter_u0_cnt[7] ;
input \usb30_device_controller_top_inst/iu3l/enter_u0_cnt[6] ;
input \usb30_device_controller_top_inst/iu3l/enter_u0_cnt[5] ;
input \usb30_device_controller_top_inst/iu3l/enter_u0_cnt[4] ;
input \usb30_device_controller_top_inst/iu3l/enter_u0_cnt[3] ;
input \usb30_device_controller_top_inst/iu3l/enter_u0_cnt[2] ;
input \usb30_device_controller_top_inst/iu3l/enter_u0_cnt[1] ;
input \usb30_device_controller_top_inst/iu3l/enter_u0_cnt[0] ;
input \usb30_device_controller_top_inst/iu3l/in_active_too_many_low ;
input \usb30_device_controller_top_inst/iu3r/iu3ep0/req_cnt[7] ;
input \usb30_device_controller_top_inst/iu3r/iu3ep0/req_cnt[6] ;
input \usb30_device_controller_top_inst/iu3r/iu3ep0/req_cnt[5] ;
input \usb30_device_controller_top_inst/iu3r/iu3ep0/req_cnt[4] ;
input \usb30_device_controller_top_inst/iu3r/iu3ep0/req_cnt[3] ;
input \usb30_device_controller_top_inst/iu3r/iu3ep0/req_cnt[2] ;
input \usb30_device_controller_top_inst/iu3r/iu3ep0/req_cnt[1] ;
input \usb30_device_controller_top_inst/iu3r/iu3ep0/req_cnt[0] ;
input \UserLayer_top_inst/ControlTransfer_inst/request_active ;
input \UserLayer_top_inst/ControlTransfer_inst/bmRequestType[7] ;
input \UserLayer_top_inst/ControlTransfer_inst/bmRequestType[6] ;
input \UserLayer_top_inst/ControlTransfer_inst/bmRequestType[5] ;
input \UserLayer_top_inst/ControlTransfer_inst/bmRequestType[4] ;
input \UserLayer_top_inst/ControlTransfer_inst/bmRequestType[3] ;
input \UserLayer_top_inst/ControlTransfer_inst/bmRequestType[2] ;
input \UserLayer_top_inst/ControlTransfer_inst/bmRequestType[1] ;
input \UserLayer_top_inst/ControlTransfer_inst/bmRequestType[0] ;
input \UserLayer_top_inst/ControlTransfer_inst/bRequest[7] ;
input \UserLayer_top_inst/ControlTransfer_inst/bRequest[6] ;
input \UserLayer_top_inst/ControlTransfer_inst/bRequest[5] ;
input \UserLayer_top_inst/ControlTransfer_inst/bRequest[4] ;
input \UserLayer_top_inst/ControlTransfer_inst/bRequest[3] ;
input \UserLayer_top_inst/ControlTransfer_inst/bRequest[2] ;
input \UserLayer_top_inst/ControlTransfer_inst/bRequest[1] ;
input \UserLayer_top_inst/ControlTransfer_inst/bRequest[0] ;
input \UserLayer_top_inst/ControlTransfer_inst/wValue[15] ;
input \UserLayer_top_inst/ControlTransfer_inst/wValue[14] ;
input \UserLayer_top_inst/ControlTransfer_inst/wValue[13] ;
input \UserLayer_top_inst/ControlTransfer_inst/wValue[12] ;
input \UserLayer_top_inst/ControlTransfer_inst/wValue[11] ;
input \UserLayer_top_inst/ControlTransfer_inst/wValue[10] ;
input \UserLayer_top_inst/ControlTransfer_inst/wValue[9] ;
input \UserLayer_top_inst/ControlTransfer_inst/wValue[8] ;
input \UserLayer_top_inst/ControlTransfer_inst/wValue[7] ;
input \UserLayer_top_inst/ControlTransfer_inst/wValue[6] ;
input \UserLayer_top_inst/ControlTransfer_inst/wValue[5] ;
input \UserLayer_top_inst/ControlTransfer_inst/wValue[4] ;
input \UserLayer_top_inst/ControlTransfer_inst/wValue[3] ;
input \UserLayer_top_inst/ControlTransfer_inst/wValue[2] ;
input \UserLayer_top_inst/ControlTransfer_inst/wValue[1] ;
input \UserLayer_top_inst/ControlTransfer_inst/wValue[0] ;
input \UserLayer_top_inst/ControlTransfer_inst/wIndex[15] ;
input \UserLayer_top_inst/ControlTransfer_inst/wIndex[14] ;
input \UserLayer_top_inst/ControlTransfer_inst/wIndex[13] ;
input \UserLayer_top_inst/ControlTransfer_inst/wIndex[12] ;
input \UserLayer_top_inst/ControlTransfer_inst/wIndex[11] ;
input \UserLayer_top_inst/ControlTransfer_inst/wIndex[10] ;
input \UserLayer_top_inst/ControlTransfer_inst/wIndex[9] ;
input \UserLayer_top_inst/ControlTransfer_inst/wIndex[8] ;
input \UserLayer_top_inst/ControlTransfer_inst/wIndex[7] ;
input \UserLayer_top_inst/ControlTransfer_inst/wIndex[6] ;
input \UserLayer_top_inst/ControlTransfer_inst/wIndex[5] ;
input \UserLayer_top_inst/ControlTransfer_inst/wIndex[4] ;
input \UserLayer_top_inst/ControlTransfer_inst/wIndex[3] ;
input \UserLayer_top_inst/ControlTransfer_inst/wIndex[2] ;
input \UserLayer_top_inst/ControlTransfer_inst/wIndex[1] ;
input \UserLayer_top_inst/ControlTransfer_inst/wIndex[0] ;
input \UserLayer_top_inst/ControlTransfer_inst/wLength[15] ;
input \UserLayer_top_inst/ControlTransfer_inst/wLength[14] ;
input \UserLayer_top_inst/ControlTransfer_inst/wLength[13] ;
input \UserLayer_top_inst/ControlTransfer_inst/wLength[12] ;
input \UserLayer_top_inst/ControlTransfer_inst/wLength[11] ;
input \UserLayer_top_inst/ControlTransfer_inst/wLength[10] ;
input \UserLayer_top_inst/ControlTransfer_inst/wLength[9] ;
input \UserLayer_top_inst/ControlTransfer_inst/wLength[8] ;
input \UserLayer_top_inst/ControlTransfer_inst/wLength[7] ;
input \UserLayer_top_inst/ControlTransfer_inst/wLength[6] ;
input \UserLayer_top_inst/ControlTransfer_inst/wLength[5] ;
input \UserLayer_top_inst/ControlTransfer_inst/wLength[4] ;
input \UserLayer_top_inst/ControlTransfer_inst/wLength[3] ;
input \UserLayer_top_inst/ControlTransfer_inst/wLength[2] ;
input \UserLayer_top_inst/ControlTransfer_inst/wLength[1] ;
input \UserLayer_top_inst/ControlTransfer_inst/wLength[0] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[31] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[30] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[29] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[28] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[27] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[26] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[25] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[24] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[23] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[22] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[21] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[20] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[19] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[18] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[17] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[16] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[15] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[14] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[13] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[12] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[11] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[10] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[9] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[8] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[7] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[6] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[5] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[4] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[3] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[2] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[1] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[0] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_wren ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_ready ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_commit ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_commit_len[10] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_commit_len[9] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_commit_len[8] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_commit_len[7] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_commit_len[6] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_commit_len[5] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_commit_len[4] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_commit_len[3] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_commit_len[2] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_commit_len[1] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_commit_len[0] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[31] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[30] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[29] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[28] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[27] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[26] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[25] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[24] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[23] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[22] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[21] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[20] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[19] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[18] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[17] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[16] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[15] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[14] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[13] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[12] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[11] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[10] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[9] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[8] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[7] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[6] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[5] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[4] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[3] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[2] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[1] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[0] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_len[10] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_len[9] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_len[8] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_len[7] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_len[6] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_len[5] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_len[4] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_len[3] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_len[2] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_len[1] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_len[0] ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_hasdata ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_rden ;
input \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_ack ;
input \usb30_device_controller_top_inst/iu3lt/dc[25] ;
input \usb30_device_controller_top_inst/iu3lt/dc[24] ;
input \usb30_device_controller_top_inst/iu3lt/dc[23] ;
input \usb30_device_controller_top_inst/iu3lt/dc[22] ;
input \usb30_device_controller_top_inst/iu3lt/dc[21] ;
input \usb30_device_controller_top_inst/iu3lt/dc[20] ;
input \usb30_device_controller_top_inst/iu3lt/dc[19] ;
input \usb30_device_controller_top_inst/iu3lt/dc[18] ;
input \usb30_device_controller_top_inst/iu3lt/dc[17] ;
input \usb30_device_controller_top_inst/iu3lt/dc[16] ;
input \usb30_device_controller_top_inst/iu3lt/dc[15] ;
input \usb30_device_controller_top_inst/iu3lt/dc[14] ;
input \usb30_device_controller_top_inst/iu3lt/dc[13] ;
input \usb30_device_controller_top_inst/iu3lt/dc[12] ;
input \usb30_device_controller_top_inst/iu3lt/dc[11] ;
input \usb30_device_controller_top_inst/iu3lt/dc[10] ;
input \usb30_device_controller_top_inst/iu3lt/dc[9] ;
input \usb30_device_controller_top_inst/iu3lt/dc[8] ;
input \usb30_device_controller_top_inst/iu3lt/dc[7] ;
input \usb30_device_controller_top_inst/iu3lt/dc[6] ;
input \usb30_device_controller_top_inst/iu3lt/dc[5] ;
input \usb30_device_controller_top_inst/iu3lt/dc[4] ;
input \usb30_device_controller_top_inst/iu3lt/dc[3] ;
input \usb30_device_controller_top_inst/iu3lt/dc[2] ;
input \usb30_device_controller_top_inst/iu3lt/dc[1] ;
input \usb30_device_controller_top_inst/iu3lt/dc[0] ;
input \usb30_device_controller_top_inst/iu3lt/partner_looking ;
input \usb30_device_controller_top_inst/iu3lt/partner_detect ;
input \usb30_device_controller_top_inst/iu3lt/partner_detected ;
input \usb30_device_controller_top_inst/iu3lt/u3_detect ;
input pclk;
input tms_pad_i;
input tck_pad_i;
input tdi_pad_i;
output tdo_pad_o;

wire \usb30_device_controller_top_inst/ltssm_state[4] ;
wire \usb30_device_controller_top_inst/ltssm_state[3] ;
wire \usb30_device_controller_top_inst/ltssm_state[2] ;
wire \usb30_device_controller_top_inst/ltssm_state[1] ;
wire \usb30_device_controller_top_inst/ltssm_state[0] ;
wire \usb30_device_controller_top_inst/iu3l/in_data[31] ;
wire \usb30_device_controller_top_inst/iu3l/in_data[30] ;
wire \usb30_device_controller_top_inst/iu3l/in_data[29] ;
wire \usb30_device_controller_top_inst/iu3l/in_data[28] ;
wire \usb30_device_controller_top_inst/iu3l/in_data[27] ;
wire \usb30_device_controller_top_inst/iu3l/in_data[26] ;
wire \usb30_device_controller_top_inst/iu3l/in_data[25] ;
wire \usb30_device_controller_top_inst/iu3l/in_data[24] ;
wire \usb30_device_controller_top_inst/iu3l/in_data[23] ;
wire \usb30_device_controller_top_inst/iu3l/in_data[22] ;
wire \usb30_device_controller_top_inst/iu3l/in_data[21] ;
wire \usb30_device_controller_top_inst/iu3l/in_data[20] ;
wire \usb30_device_controller_top_inst/iu3l/in_data[19] ;
wire \usb30_device_controller_top_inst/iu3l/in_data[18] ;
wire \usb30_device_controller_top_inst/iu3l/in_data[17] ;
wire \usb30_device_controller_top_inst/iu3l/in_data[16] ;
wire \usb30_device_controller_top_inst/iu3l/in_data[15] ;
wire \usb30_device_controller_top_inst/iu3l/in_data[14] ;
wire \usb30_device_controller_top_inst/iu3l/in_data[13] ;
wire \usb30_device_controller_top_inst/iu3l/in_data[12] ;
wire \usb30_device_controller_top_inst/iu3l/in_data[11] ;
wire \usb30_device_controller_top_inst/iu3l/in_data[10] ;
wire \usb30_device_controller_top_inst/iu3l/in_data[9] ;
wire \usb30_device_controller_top_inst/iu3l/in_data[8] ;
wire \usb30_device_controller_top_inst/iu3l/in_data[7] ;
wire \usb30_device_controller_top_inst/iu3l/in_data[6] ;
wire \usb30_device_controller_top_inst/iu3l/in_data[5] ;
wire \usb30_device_controller_top_inst/iu3l/in_data[4] ;
wire \usb30_device_controller_top_inst/iu3l/in_data[3] ;
wire \usb30_device_controller_top_inst/iu3l/in_data[2] ;
wire \usb30_device_controller_top_inst/iu3l/in_data[1] ;
wire \usb30_device_controller_top_inst/iu3l/in_data[0] ;
wire \usb30_device_controller_top_inst/iu3l/in_datak[3] ;
wire \usb30_device_controller_top_inst/iu3l/in_datak[2] ;
wire \usb30_device_controller_top_inst/iu3l/in_datak[1] ;
wire \usb30_device_controller_top_inst/iu3l/in_datak[0] ;
wire \usb30_device_controller_top_inst/iu3l/in_active ;
wire \usb30_device_controller_top_inst/iu3l/outp_data[31] ;
wire \usb30_device_controller_top_inst/iu3l/outp_data[30] ;
wire \usb30_device_controller_top_inst/iu3l/outp_data[29] ;
wire \usb30_device_controller_top_inst/iu3l/outp_data[28] ;
wire \usb30_device_controller_top_inst/iu3l/outp_data[27] ;
wire \usb30_device_controller_top_inst/iu3l/outp_data[26] ;
wire \usb30_device_controller_top_inst/iu3l/outp_data[25] ;
wire \usb30_device_controller_top_inst/iu3l/outp_data[24] ;
wire \usb30_device_controller_top_inst/iu3l/outp_data[23] ;
wire \usb30_device_controller_top_inst/iu3l/outp_data[22] ;
wire \usb30_device_controller_top_inst/iu3l/outp_data[21] ;
wire \usb30_device_controller_top_inst/iu3l/outp_data[20] ;
wire \usb30_device_controller_top_inst/iu3l/outp_data[19] ;
wire \usb30_device_controller_top_inst/iu3l/outp_data[18] ;
wire \usb30_device_controller_top_inst/iu3l/outp_data[17] ;
wire \usb30_device_controller_top_inst/iu3l/outp_data[16] ;
wire \usb30_device_controller_top_inst/iu3l/outp_data[15] ;
wire \usb30_device_controller_top_inst/iu3l/outp_data[14] ;
wire \usb30_device_controller_top_inst/iu3l/outp_data[13] ;
wire \usb30_device_controller_top_inst/iu3l/outp_data[12] ;
wire \usb30_device_controller_top_inst/iu3l/outp_data[11] ;
wire \usb30_device_controller_top_inst/iu3l/outp_data[10] ;
wire \usb30_device_controller_top_inst/iu3l/outp_data[9] ;
wire \usb30_device_controller_top_inst/iu3l/outp_data[8] ;
wire \usb30_device_controller_top_inst/iu3l/outp_data[7] ;
wire \usb30_device_controller_top_inst/iu3l/outp_data[6] ;
wire \usb30_device_controller_top_inst/iu3l/outp_data[5] ;
wire \usb30_device_controller_top_inst/iu3l/outp_data[4] ;
wire \usb30_device_controller_top_inst/iu3l/outp_data[3] ;
wire \usb30_device_controller_top_inst/iu3l/outp_data[2] ;
wire \usb30_device_controller_top_inst/iu3l/outp_data[1] ;
wire \usb30_device_controller_top_inst/iu3l/outp_data[0] ;
wire \usb30_device_controller_top_inst/iu3l/outp_datak[3] ;
wire \usb30_device_controller_top_inst/iu3l/outp_datak[2] ;
wire \usb30_device_controller_top_inst/iu3l/outp_datak[1] ;
wire \usb30_device_controller_top_inst/iu3l/outp_datak[0] ;
wire \usb30_device_controller_top_inst/iu3l/outp_active ;
wire \usb30_device_controller_top_inst/iu3l/ltssm_go_recovery ;
wire \usb30_device_controller_top_inst/iu3l/err_hp_seq ;
wire \usb30_device_controller_top_inst/iu3l/err_lgood_order ;
wire \usb30_device_controller_top_inst/iu3l/err_lcrd_mismatch ;
wire \usb30_device_controller_top_inst/iu3l/tx_hdr_seq_num[2] ;
wire \usb30_device_controller_top_inst/iu3l/tx_hdr_seq_num[1] ;
wire \usb30_device_controller_top_inst/iu3l/tx_hdr_seq_num[0] ;
wire \usb30_device_controller_top_inst/iu3l/rx_hdr_seq_num[2] ;
wire \usb30_device_controller_top_inst/iu3l/rx_hdr_seq_num[1] ;
wire \usb30_device_controller_top_inst/iu3l/rx_hdr_seq_num[0] ;
wire \usb30_device_controller_top_inst/iu3l/ack_tx_hdr_seq_num[2] ;
wire \usb30_device_controller_top_inst/iu3l/ack_tx_hdr_seq_num[1] ;
wire \usb30_device_controller_top_inst/iu3l/ack_tx_hdr_seq_num[0] ;
wire \usb30_device_controller_top_inst/iu3l/tx_cred_idx[1] ;
wire \usb30_device_controller_top_inst/iu3l/tx_cred_idx[0] ;
wire \usb30_device_controller_top_inst/iu3l/enter_u0_cnt[7] ;
wire \usb30_device_controller_top_inst/iu3l/enter_u0_cnt[6] ;
wire \usb30_device_controller_top_inst/iu3l/enter_u0_cnt[5] ;
wire \usb30_device_controller_top_inst/iu3l/enter_u0_cnt[4] ;
wire \usb30_device_controller_top_inst/iu3l/enter_u0_cnt[3] ;
wire \usb30_device_controller_top_inst/iu3l/enter_u0_cnt[2] ;
wire \usb30_device_controller_top_inst/iu3l/enter_u0_cnt[1] ;
wire \usb30_device_controller_top_inst/iu3l/enter_u0_cnt[0] ;
wire \usb30_device_controller_top_inst/iu3l/in_active_too_many_low ;
wire \usb30_device_controller_top_inst/iu3r/iu3ep0/req_cnt[7] ;
wire \usb30_device_controller_top_inst/iu3r/iu3ep0/req_cnt[6] ;
wire \usb30_device_controller_top_inst/iu3r/iu3ep0/req_cnt[5] ;
wire \usb30_device_controller_top_inst/iu3r/iu3ep0/req_cnt[4] ;
wire \usb30_device_controller_top_inst/iu3r/iu3ep0/req_cnt[3] ;
wire \usb30_device_controller_top_inst/iu3r/iu3ep0/req_cnt[2] ;
wire \usb30_device_controller_top_inst/iu3r/iu3ep0/req_cnt[1] ;
wire \usb30_device_controller_top_inst/iu3r/iu3ep0/req_cnt[0] ;
wire \UserLayer_top_inst/ControlTransfer_inst/request_active ;
wire \UserLayer_top_inst/ControlTransfer_inst/bmRequestType[7] ;
wire \UserLayer_top_inst/ControlTransfer_inst/bmRequestType[6] ;
wire \UserLayer_top_inst/ControlTransfer_inst/bmRequestType[5] ;
wire \UserLayer_top_inst/ControlTransfer_inst/bmRequestType[4] ;
wire \UserLayer_top_inst/ControlTransfer_inst/bmRequestType[3] ;
wire \UserLayer_top_inst/ControlTransfer_inst/bmRequestType[2] ;
wire \UserLayer_top_inst/ControlTransfer_inst/bmRequestType[1] ;
wire \UserLayer_top_inst/ControlTransfer_inst/bmRequestType[0] ;
wire \UserLayer_top_inst/ControlTransfer_inst/bRequest[7] ;
wire \UserLayer_top_inst/ControlTransfer_inst/bRequest[6] ;
wire \UserLayer_top_inst/ControlTransfer_inst/bRequest[5] ;
wire \UserLayer_top_inst/ControlTransfer_inst/bRequest[4] ;
wire \UserLayer_top_inst/ControlTransfer_inst/bRequest[3] ;
wire \UserLayer_top_inst/ControlTransfer_inst/bRequest[2] ;
wire \UserLayer_top_inst/ControlTransfer_inst/bRequest[1] ;
wire \UserLayer_top_inst/ControlTransfer_inst/bRequest[0] ;
wire \UserLayer_top_inst/ControlTransfer_inst/wValue[15] ;
wire \UserLayer_top_inst/ControlTransfer_inst/wValue[14] ;
wire \UserLayer_top_inst/ControlTransfer_inst/wValue[13] ;
wire \UserLayer_top_inst/ControlTransfer_inst/wValue[12] ;
wire \UserLayer_top_inst/ControlTransfer_inst/wValue[11] ;
wire \UserLayer_top_inst/ControlTransfer_inst/wValue[10] ;
wire \UserLayer_top_inst/ControlTransfer_inst/wValue[9] ;
wire \UserLayer_top_inst/ControlTransfer_inst/wValue[8] ;
wire \UserLayer_top_inst/ControlTransfer_inst/wValue[7] ;
wire \UserLayer_top_inst/ControlTransfer_inst/wValue[6] ;
wire \UserLayer_top_inst/ControlTransfer_inst/wValue[5] ;
wire \UserLayer_top_inst/ControlTransfer_inst/wValue[4] ;
wire \UserLayer_top_inst/ControlTransfer_inst/wValue[3] ;
wire \UserLayer_top_inst/ControlTransfer_inst/wValue[2] ;
wire \UserLayer_top_inst/ControlTransfer_inst/wValue[1] ;
wire \UserLayer_top_inst/ControlTransfer_inst/wValue[0] ;
wire \UserLayer_top_inst/ControlTransfer_inst/wIndex[15] ;
wire \UserLayer_top_inst/ControlTransfer_inst/wIndex[14] ;
wire \UserLayer_top_inst/ControlTransfer_inst/wIndex[13] ;
wire \UserLayer_top_inst/ControlTransfer_inst/wIndex[12] ;
wire \UserLayer_top_inst/ControlTransfer_inst/wIndex[11] ;
wire \UserLayer_top_inst/ControlTransfer_inst/wIndex[10] ;
wire \UserLayer_top_inst/ControlTransfer_inst/wIndex[9] ;
wire \UserLayer_top_inst/ControlTransfer_inst/wIndex[8] ;
wire \UserLayer_top_inst/ControlTransfer_inst/wIndex[7] ;
wire \UserLayer_top_inst/ControlTransfer_inst/wIndex[6] ;
wire \UserLayer_top_inst/ControlTransfer_inst/wIndex[5] ;
wire \UserLayer_top_inst/ControlTransfer_inst/wIndex[4] ;
wire \UserLayer_top_inst/ControlTransfer_inst/wIndex[3] ;
wire \UserLayer_top_inst/ControlTransfer_inst/wIndex[2] ;
wire \UserLayer_top_inst/ControlTransfer_inst/wIndex[1] ;
wire \UserLayer_top_inst/ControlTransfer_inst/wIndex[0] ;
wire \UserLayer_top_inst/ControlTransfer_inst/wLength[15] ;
wire \UserLayer_top_inst/ControlTransfer_inst/wLength[14] ;
wire \UserLayer_top_inst/ControlTransfer_inst/wLength[13] ;
wire \UserLayer_top_inst/ControlTransfer_inst/wLength[12] ;
wire \UserLayer_top_inst/ControlTransfer_inst/wLength[11] ;
wire \UserLayer_top_inst/ControlTransfer_inst/wLength[10] ;
wire \UserLayer_top_inst/ControlTransfer_inst/wLength[9] ;
wire \UserLayer_top_inst/ControlTransfer_inst/wLength[8] ;
wire \UserLayer_top_inst/ControlTransfer_inst/wLength[7] ;
wire \UserLayer_top_inst/ControlTransfer_inst/wLength[6] ;
wire \UserLayer_top_inst/ControlTransfer_inst/wLength[5] ;
wire \UserLayer_top_inst/ControlTransfer_inst/wLength[4] ;
wire \UserLayer_top_inst/ControlTransfer_inst/wLength[3] ;
wire \UserLayer_top_inst/ControlTransfer_inst/wLength[2] ;
wire \UserLayer_top_inst/ControlTransfer_inst/wLength[1] ;
wire \UserLayer_top_inst/ControlTransfer_inst/wLength[0] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[31] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[30] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[29] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[28] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[27] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[26] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[25] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[24] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[23] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[22] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[21] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[20] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[19] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[18] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[17] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[16] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[15] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[14] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[13] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[12] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[11] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[10] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[9] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[8] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[7] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[6] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[5] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[4] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[3] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[2] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[1] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[0] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_wren ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_ready ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_commit ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_commit_len[10] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_commit_len[9] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_commit_len[8] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_commit_len[7] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_commit_len[6] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_commit_len[5] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_commit_len[4] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_commit_len[3] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_commit_len[2] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_commit_len[1] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_commit_len[0] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[31] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[30] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[29] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[28] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[27] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[26] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[25] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[24] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[23] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[22] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[21] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[20] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[19] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[18] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[17] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[16] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[15] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[14] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[13] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[12] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[11] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[10] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[9] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[8] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[7] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[6] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[5] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[4] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[3] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[2] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[1] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[0] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_len[10] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_len[9] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_len[8] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_len[7] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_len[6] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_len[5] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_len[4] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_len[3] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_len[2] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_len[1] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_len[0] ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_hasdata ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_rden ;
wire \UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_ack ;
wire \usb30_device_controller_top_inst/iu3lt/dc[25] ;
wire \usb30_device_controller_top_inst/iu3lt/dc[24] ;
wire \usb30_device_controller_top_inst/iu3lt/dc[23] ;
wire \usb30_device_controller_top_inst/iu3lt/dc[22] ;
wire \usb30_device_controller_top_inst/iu3lt/dc[21] ;
wire \usb30_device_controller_top_inst/iu3lt/dc[20] ;
wire \usb30_device_controller_top_inst/iu3lt/dc[19] ;
wire \usb30_device_controller_top_inst/iu3lt/dc[18] ;
wire \usb30_device_controller_top_inst/iu3lt/dc[17] ;
wire \usb30_device_controller_top_inst/iu3lt/dc[16] ;
wire \usb30_device_controller_top_inst/iu3lt/dc[15] ;
wire \usb30_device_controller_top_inst/iu3lt/dc[14] ;
wire \usb30_device_controller_top_inst/iu3lt/dc[13] ;
wire \usb30_device_controller_top_inst/iu3lt/dc[12] ;
wire \usb30_device_controller_top_inst/iu3lt/dc[11] ;
wire \usb30_device_controller_top_inst/iu3lt/dc[10] ;
wire \usb30_device_controller_top_inst/iu3lt/dc[9] ;
wire \usb30_device_controller_top_inst/iu3lt/dc[8] ;
wire \usb30_device_controller_top_inst/iu3lt/dc[7] ;
wire \usb30_device_controller_top_inst/iu3lt/dc[6] ;
wire \usb30_device_controller_top_inst/iu3lt/dc[5] ;
wire \usb30_device_controller_top_inst/iu3lt/dc[4] ;
wire \usb30_device_controller_top_inst/iu3lt/dc[3] ;
wire \usb30_device_controller_top_inst/iu3lt/dc[2] ;
wire \usb30_device_controller_top_inst/iu3lt/dc[1] ;
wire \usb30_device_controller_top_inst/iu3lt/dc[0] ;
wire \usb30_device_controller_top_inst/iu3lt/partner_looking ;
wire \usb30_device_controller_top_inst/iu3lt/partner_detect ;
wire \usb30_device_controller_top_inst/iu3lt/partner_detected ;
wire \usb30_device_controller_top_inst/iu3lt/u3_detect ;
wire pclk;
wire tms_pad_i;
wire tck_pad_i;
wire tdi_pad_i;
wire tdo_pad_o;
wire tms_i_c;
wire tck_i_c;
wire tdi_i_c;
wire tdo_o_c;
wire [9:0] control0;
wire gao_jtag_tck;
wire gao_jtag_reset;
wire run_test_idle_er1;
wire run_test_idle_er2;
wire shift_dr_capture_dr;
wire update_dr;
wire pause_dr;
wire enable_er1;
wire enable_er2;
wire gao_jtag_tdi;
wire tdo_er1;

IBUF tms_ibuf (
    .I(tms_pad_i),
    .O(tms_i_c)
);

IBUF tck_ibuf (
    .I(tck_pad_i),
    .O(tck_i_c)
);

IBUF tdi_ibuf (
    .I(tdi_pad_i),
    .O(tdi_i_c)
);

OBUF tdo_obuf (
    .I(tdo_o_c),
    .O(tdo_pad_o)
);

GW_JTAG  u_gw_jtag(
    .tms_pad_i(tms_i_c),
    .tck_pad_i(tck_i_c),
    .tdi_pad_i(tdi_i_c),
    .tdo_pad_o(tdo_o_c),
    .tck_o(gao_jtag_tck),
    .test_logic_reset_o(gao_jtag_reset),
    .run_test_idle_er1_o(run_test_idle_er1),
    .run_test_idle_er2_o(run_test_idle_er2),
    .shift_dr_capture_dr_o(shift_dr_capture_dr),
    .update_dr_o(update_dr),
    .pause_dr_o(pause_dr),
    .enable_er1_o(enable_er1),
    .enable_er2_o(enable_er2),
    .tdi_o(gao_jtag_tdi),
    .tdo_er1_i(tdo_er1),
    .tdo_er2_i(1'b0)
);

gw_con_top  u_icon_top(
    .tck_i(gao_jtag_tck),
    .tdi_i(gao_jtag_tdi),
    .tdo_o(tdo_er1),
    .rst_i(gao_jtag_reset),
    .control0(control0[9:0]),
    .enable_i(enable_er1),
    .shift_dr_capture_dr_i(shift_dr_capture_dr),
    .update_dr_i(update_dr)
);

ao_top_0  u_la0_top(
    .control(control0[9:0]),
    .trig0_i({\usb30_device_controller_top_inst/ltssm_state[4] ,\usb30_device_controller_top_inst/ltssm_state[3] ,\usb30_device_controller_top_inst/ltssm_state[2] ,\usb30_device_controller_top_inst/ltssm_state[1] ,\usb30_device_controller_top_inst/ltssm_state[0] }),
    .trig1_i({\usb30_device_controller_top_inst/iu3lt/u3_detect ,\usb30_device_controller_top_inst/iu3lt/partner_looking }),
    .trig2_i(\usb30_device_controller_top_inst/iu3l/in_active_too_many_low ),
    .data_i({\usb30_device_controller_top_inst/ltssm_state[4] ,\usb30_device_controller_top_inst/ltssm_state[3] ,\usb30_device_controller_top_inst/ltssm_state[2] ,\usb30_device_controller_top_inst/ltssm_state[1] ,\usb30_device_controller_top_inst/ltssm_state[0] ,\usb30_device_controller_top_inst/iu3l/in_data[31] ,\usb30_device_controller_top_inst/iu3l/in_data[30] ,\usb30_device_controller_top_inst/iu3l/in_data[29] ,\usb30_device_controller_top_inst/iu3l/in_data[28] ,\usb30_device_controller_top_inst/iu3l/in_data[27] ,\usb30_device_controller_top_inst/iu3l/in_data[26] ,\usb30_device_controller_top_inst/iu3l/in_data[25] ,\usb30_device_controller_top_inst/iu3l/in_data[24] ,\usb30_device_controller_top_inst/iu3l/in_data[23] ,\usb30_device_controller_top_inst/iu3l/in_data[22] ,\usb30_device_controller_top_inst/iu3l/in_data[21] ,\usb30_device_controller_top_inst/iu3l/in_data[20] ,\usb30_device_controller_top_inst/iu3l/in_data[19] ,\usb30_device_controller_top_inst/iu3l/in_data[18] ,\usb30_device_controller_top_inst/iu3l/in_data[17] ,\usb30_device_controller_top_inst/iu3l/in_data[16] ,\usb30_device_controller_top_inst/iu3l/in_data[15] ,\usb30_device_controller_top_inst/iu3l/in_data[14] ,\usb30_device_controller_top_inst/iu3l/in_data[13] ,\usb30_device_controller_top_inst/iu3l/in_data[12] ,\usb30_device_controller_top_inst/iu3l/in_data[11] ,\usb30_device_controller_top_inst/iu3l/in_data[10] ,\usb30_device_controller_top_inst/iu3l/in_data[9] ,\usb30_device_controller_top_inst/iu3l/in_data[8] ,\usb30_device_controller_top_inst/iu3l/in_data[7] ,\usb30_device_controller_top_inst/iu3l/in_data[6] ,\usb30_device_controller_top_inst/iu3l/in_data[5] ,\usb30_device_controller_top_inst/iu3l/in_data[4] ,\usb30_device_controller_top_inst/iu3l/in_data[3] ,\usb30_device_controller_top_inst/iu3l/in_data[2] ,\usb30_device_controller_top_inst/iu3l/in_data[1] ,\usb30_device_controller_top_inst/iu3l/in_data[0] ,\usb30_device_controller_top_inst/iu3l/in_datak[3] ,\usb30_device_controller_top_inst/iu3l/in_datak[2] ,\usb30_device_controller_top_inst/iu3l/in_datak[1] ,\usb30_device_controller_top_inst/iu3l/in_datak[0] ,\usb30_device_controller_top_inst/iu3l/in_active ,\usb30_device_controller_top_inst/iu3l/outp_data[31] ,\usb30_device_controller_top_inst/iu3l/outp_data[30] ,\usb30_device_controller_top_inst/iu3l/outp_data[29] ,\usb30_device_controller_top_inst/iu3l/outp_data[28] ,\usb30_device_controller_top_inst/iu3l/outp_data[27] ,\usb30_device_controller_top_inst/iu3l/outp_data[26] ,\usb30_device_controller_top_inst/iu3l/outp_data[25] ,\usb30_device_controller_top_inst/iu3l/outp_data[24] ,\usb30_device_controller_top_inst/iu3l/outp_data[23] ,\usb30_device_controller_top_inst/iu3l/outp_data[22] ,\usb30_device_controller_top_inst/iu3l/outp_data[21] ,\usb30_device_controller_top_inst/iu3l/outp_data[20] ,\usb30_device_controller_top_inst/iu3l/outp_data[19] ,\usb30_device_controller_top_inst/iu3l/outp_data[18] ,\usb30_device_controller_top_inst/iu3l/outp_data[17] ,\usb30_device_controller_top_inst/iu3l/outp_data[16] ,\usb30_device_controller_top_inst/iu3l/outp_data[15] ,\usb30_device_controller_top_inst/iu3l/outp_data[14] ,\usb30_device_controller_top_inst/iu3l/outp_data[13] ,\usb30_device_controller_top_inst/iu3l/outp_data[12] ,\usb30_device_controller_top_inst/iu3l/outp_data[11] ,\usb30_device_controller_top_inst/iu3l/outp_data[10] ,\usb30_device_controller_top_inst/iu3l/outp_data[9] ,\usb30_device_controller_top_inst/iu3l/outp_data[8] ,\usb30_device_controller_top_inst/iu3l/outp_data[7] ,\usb30_device_controller_top_inst/iu3l/outp_data[6] ,\usb30_device_controller_top_inst/iu3l/outp_data[5] ,\usb30_device_controller_top_inst/iu3l/outp_data[4] ,\usb30_device_controller_top_inst/iu3l/outp_data[3] ,\usb30_device_controller_top_inst/iu3l/outp_data[2] ,\usb30_device_controller_top_inst/iu3l/outp_data[1] ,\usb30_device_controller_top_inst/iu3l/outp_data[0] ,\usb30_device_controller_top_inst/iu3l/outp_datak[3] ,\usb30_device_controller_top_inst/iu3l/outp_datak[2] ,\usb30_device_controller_top_inst/iu3l/outp_datak[1] ,\usb30_device_controller_top_inst/iu3l/outp_datak[0] ,\usb30_device_controller_top_inst/iu3l/outp_active ,\usb30_device_controller_top_inst/iu3l/ltssm_go_recovery ,\usb30_device_controller_top_inst/iu3l/err_hp_seq ,\usb30_device_controller_top_inst/iu3l/err_lgood_order ,\usb30_device_controller_top_inst/iu3l/err_lcrd_mismatch ,\usb30_device_controller_top_inst/iu3l/tx_hdr_seq_num[2] ,\usb30_device_controller_top_inst/iu3l/tx_hdr_seq_num[1] ,\usb30_device_controller_top_inst/iu3l/tx_hdr_seq_num[0] ,\usb30_device_controller_top_inst/iu3l/rx_hdr_seq_num[2] ,\usb30_device_controller_top_inst/iu3l/rx_hdr_seq_num[1] ,\usb30_device_controller_top_inst/iu3l/rx_hdr_seq_num[0] ,\usb30_device_controller_top_inst/iu3l/ack_tx_hdr_seq_num[2] ,\usb30_device_controller_top_inst/iu3l/ack_tx_hdr_seq_num[1] ,\usb30_device_controller_top_inst/iu3l/ack_tx_hdr_seq_num[0] ,\usb30_device_controller_top_inst/iu3l/tx_cred_idx[1] ,\usb30_device_controller_top_inst/iu3l/tx_cred_idx[0] ,\usb30_device_controller_top_inst/iu3l/enter_u0_cnt[7] ,\usb30_device_controller_top_inst/iu3l/enter_u0_cnt[6] ,\usb30_device_controller_top_inst/iu3l/enter_u0_cnt[5] ,\usb30_device_controller_top_inst/iu3l/enter_u0_cnt[4] ,\usb30_device_controller_top_inst/iu3l/enter_u0_cnt[3] ,\usb30_device_controller_top_inst/iu3l/enter_u0_cnt[2] ,\usb30_device_controller_top_inst/iu3l/enter_u0_cnt[1] ,\usb30_device_controller_top_inst/iu3l/enter_u0_cnt[0] ,\usb30_device_controller_top_inst/iu3l/in_active_too_many_low ,\usb30_device_controller_top_inst/iu3r/iu3ep0/req_cnt[7] ,\usb30_device_controller_top_inst/iu3r/iu3ep0/req_cnt[6] ,\usb30_device_controller_top_inst/iu3r/iu3ep0/req_cnt[5] ,\usb30_device_controller_top_inst/iu3r/iu3ep0/req_cnt[4] ,\usb30_device_controller_top_inst/iu3r/iu3ep0/req_cnt[3] ,\usb30_device_controller_top_inst/iu3r/iu3ep0/req_cnt[2] ,\usb30_device_controller_top_inst/iu3r/iu3ep0/req_cnt[1] ,\usb30_device_controller_top_inst/iu3r/iu3ep0/req_cnt[0] ,\UserLayer_top_inst/ControlTransfer_inst/request_active ,\UserLayer_top_inst/ControlTransfer_inst/bmRequestType[7] ,\UserLayer_top_inst/ControlTransfer_inst/bmRequestType[6] ,\UserLayer_top_inst/ControlTransfer_inst/bmRequestType[5] ,\UserLayer_top_inst/ControlTransfer_inst/bmRequestType[4] ,\UserLayer_top_inst/ControlTransfer_inst/bmRequestType[3] ,\UserLayer_top_inst/ControlTransfer_inst/bmRequestType[2] ,\UserLayer_top_inst/ControlTransfer_inst/bmRequestType[1] ,\UserLayer_top_inst/ControlTransfer_inst/bmRequestType[0] ,\UserLayer_top_inst/ControlTransfer_inst/bRequest[7] ,\UserLayer_top_inst/ControlTransfer_inst/bRequest[6] ,\UserLayer_top_inst/ControlTransfer_inst/bRequest[5] ,\UserLayer_top_inst/ControlTransfer_inst/bRequest[4] ,\UserLayer_top_inst/ControlTransfer_inst/bRequest[3] ,\UserLayer_top_inst/ControlTransfer_inst/bRequest[2] ,\UserLayer_top_inst/ControlTransfer_inst/bRequest[1] ,\UserLayer_top_inst/ControlTransfer_inst/bRequest[0] ,\UserLayer_top_inst/ControlTransfer_inst/wValue[15] ,\UserLayer_top_inst/ControlTransfer_inst/wValue[14] ,\UserLayer_top_inst/ControlTransfer_inst/wValue[13] ,\UserLayer_top_inst/ControlTransfer_inst/wValue[12] ,\UserLayer_top_inst/ControlTransfer_inst/wValue[11] ,\UserLayer_top_inst/ControlTransfer_inst/wValue[10] ,\UserLayer_top_inst/ControlTransfer_inst/wValue[9] ,\UserLayer_top_inst/ControlTransfer_inst/wValue[8] ,\UserLayer_top_inst/ControlTransfer_inst/wValue[7] ,\UserLayer_top_inst/ControlTransfer_inst/wValue[6] ,\UserLayer_top_inst/ControlTransfer_inst/wValue[5] ,\UserLayer_top_inst/ControlTransfer_inst/wValue[4] ,\UserLayer_top_inst/ControlTransfer_inst/wValue[3] ,\UserLayer_top_inst/ControlTransfer_inst/wValue[2] ,\UserLayer_top_inst/ControlTransfer_inst/wValue[1] ,\UserLayer_top_inst/ControlTransfer_inst/wValue[0] ,\UserLayer_top_inst/ControlTransfer_inst/wIndex[15] ,\UserLayer_top_inst/ControlTransfer_inst/wIndex[14] ,\UserLayer_top_inst/ControlTransfer_inst/wIndex[13] ,\UserLayer_top_inst/ControlTransfer_inst/wIndex[12] ,\UserLayer_top_inst/ControlTransfer_inst/wIndex[11] ,\UserLayer_top_inst/ControlTransfer_inst/wIndex[10] ,\UserLayer_top_inst/ControlTransfer_inst/wIndex[9] ,\UserLayer_top_inst/ControlTransfer_inst/wIndex[8] ,\UserLayer_top_inst/ControlTransfer_inst/wIndex[7] ,\UserLayer_top_inst/ControlTransfer_inst/wIndex[6] ,\UserLayer_top_inst/ControlTransfer_inst/wIndex[5] ,\UserLayer_top_inst/ControlTransfer_inst/wIndex[4] ,\UserLayer_top_inst/ControlTransfer_inst/wIndex[3] ,\UserLayer_top_inst/ControlTransfer_inst/wIndex[2] ,\UserLayer_top_inst/ControlTransfer_inst/wIndex[1] ,\UserLayer_top_inst/ControlTransfer_inst/wIndex[0] ,\UserLayer_top_inst/ControlTransfer_inst/wLength[15] ,\UserLayer_top_inst/ControlTransfer_inst/wLength[14] ,\UserLayer_top_inst/ControlTransfer_inst/wLength[13] ,\UserLayer_top_inst/ControlTransfer_inst/wLength[12] ,\UserLayer_top_inst/ControlTransfer_inst/wLength[11] ,\UserLayer_top_inst/ControlTransfer_inst/wLength[10] ,\UserLayer_top_inst/ControlTransfer_inst/wLength[9] ,\UserLayer_top_inst/ControlTransfer_inst/wLength[8] ,\UserLayer_top_inst/ControlTransfer_inst/wLength[7] ,\UserLayer_top_inst/ControlTransfer_inst/wLength[6] ,\UserLayer_top_inst/ControlTransfer_inst/wLength[5] ,\UserLayer_top_inst/ControlTransfer_inst/wLength[4] ,\UserLayer_top_inst/ControlTransfer_inst/wLength[3] ,\UserLayer_top_inst/ControlTransfer_inst/wLength[2] ,\UserLayer_top_inst/ControlTransfer_inst/wLength[1] ,\UserLayer_top_inst/ControlTransfer_inst/wLength[0] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[31] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[30] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[29] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[28] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[27] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[26] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[25] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[24] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[23] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[22] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[21] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[20] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[19] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[18] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[17] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[16] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[15] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[14] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[13] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[12] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[11] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[10] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[9] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[8] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[7] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[6] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[5] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[4] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[3] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[2] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[1] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_data[0] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_wren ,\UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_ready ,\UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_commit ,\UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_commit_len[10] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_commit_len[9] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_commit_len[8] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_commit_len[7] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_commit_len[6] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_commit_len[5] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_commit_len[4] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_commit_len[3] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_commit_len[2] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_commit_len[1] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_in_buf_commit_len[0] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[31] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[30] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[29] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[28] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[27] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[26] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[25] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[24] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[23] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[22] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[21] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[20] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[19] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[18] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[17] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[16] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[15] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[14] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[13] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[12] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[11] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[10] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[9] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[8] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[7] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[6] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[5] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[4] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[3] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[2] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[1] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_data[0] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_len[10] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_len[9] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_len[8] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_len[7] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_len[6] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_len[5] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_len[4] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_len[3] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_len[2] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_len[1] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_len[0] ,\UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_hasdata ,\UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_rden ,\UserLayer_top_inst/ControlTransfer_inst/ep0_out_buf_ack ,\usb30_device_controller_top_inst/iu3lt/dc[25] ,\usb30_device_controller_top_inst/iu3lt/dc[24] ,\usb30_device_controller_top_inst/iu3lt/dc[23] ,\usb30_device_controller_top_inst/iu3lt/dc[22] ,\usb30_device_controller_top_inst/iu3lt/dc[21] ,\usb30_device_controller_top_inst/iu3lt/dc[20] ,\usb30_device_controller_top_inst/iu3lt/dc[19] ,\usb30_device_controller_top_inst/iu3lt/dc[18] ,\usb30_device_controller_top_inst/iu3lt/dc[17] ,\usb30_device_controller_top_inst/iu3lt/dc[16] ,\usb30_device_controller_top_inst/iu3lt/dc[15] ,\usb30_device_controller_top_inst/iu3lt/dc[14] ,\usb30_device_controller_top_inst/iu3lt/dc[13] ,\usb30_device_controller_top_inst/iu3lt/dc[12] ,\usb30_device_controller_top_inst/iu3lt/dc[11] ,\usb30_device_controller_top_inst/iu3lt/dc[10] ,\usb30_device_controller_top_inst/iu3lt/dc[9] ,\usb30_device_controller_top_inst/iu3lt/dc[8] ,\usb30_device_controller_top_inst/iu3lt/dc[7] ,\usb30_device_controller_top_inst/iu3lt/dc[6] ,\usb30_device_controller_top_inst/iu3lt/dc[5] ,\usb30_device_controller_top_inst/iu3lt/dc[4] ,\usb30_device_controller_top_inst/iu3lt/dc[3] ,\usb30_device_controller_top_inst/iu3lt/dc[2] ,\usb30_device_controller_top_inst/iu3lt/dc[1] ,\usb30_device_controller_top_inst/iu3lt/dc[0] ,\usb30_device_controller_top_inst/iu3lt/partner_looking ,\usb30_device_controller_top_inst/iu3lt/partner_detect ,\usb30_device_controller_top_inst/iu3lt/partner_detected }),
    .clk_i(pclk)
);

endmodule
