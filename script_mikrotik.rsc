# by saulo costa
:global data "name,comment,linkdowns,rxbyte,txbyte,sfpTxPower,sfpRxPower,sfpTemperature,rate,sfpVendorSerial,sfpSupplyVoltage,sfpTxBiasCurrent";
:global lista [/interface ethernet find running~"true"];
:foreach i in=$lista do={\
    # GET
    :global name [/interface ethernet get $i name];
    :global comment [/interface ethernet get $i comment];
    :global linkdowns  [/interface get $i link-downs];
    :global rxbyte  [/interface get $i rx-byte];
    :global txbyte  [/interface get $i tx-byte];

    # MONITOR
    :global monitor [/interface ethernet monitor $i once as-value];
        :global sfpTxPower ($monitor->"sfp-tx-power");
        :global sfpRxPower ($monitor->"sfp-rx-power");
        :global sfpTemperature ($monitor->"sfp-temperature");
        :global rate ($monitor->"rate");
        :global sfpVendorSerial ($monitor->"sfp-vendor-serial");
        :global sfpSupplyVoltage ($monitor->"sfp-supply-voltage");
        :global sfpTxBiasCurrent ($monitor->"sfp-tx-bias-current");
            if ($sfpTxBiasCurrent = "") do={set $sfpTxBiasCurrent 0};

    :set $data ($data."|".$name.",".$comment.",".$linkdowns.",".$rxbyte.",".$txbyte.",".$sfpTxPower.",".$sfpRxPower.",".$sfpTemperature.",".$rate.",".$sfpVendorSerial.",".$sfpSupplyVoltage.",".$sfpTxBiasCurrent);

    # :delay 1s;
}
/snmp send-trap oid=1.3.6.444.445 type=string value=$data;
### 