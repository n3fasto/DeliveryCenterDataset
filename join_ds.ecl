﻿IMPORT $;

EXPORT join_ds := MODULE
  rec_hubs := $.record_optimized.rec_hubs;
  rec_payments := $.record_optimized.rec_payments;
  rec_stores := $.record_optimized.rec_stores;
  rec_deliveries := $.record_optimized.rec_deliveries;
  rec_drivers := $.record_optimized.rec_drivers;
  rec_channels := $.record_optimized.rec_channels;
  rec_orders := $.record_optimized.rec_orders;

  hubs := $.record_optimized.hubs;
  payments := $.record_optimized.payments;
  stores := $.record_optimized.stores;
  deliveries := $.record_optimized.deliveries;
  drivers := $.record_optimized.drivers;
  channels := $.record_optimized.channels;
  orders := $.record_optimized.orders;

  outrec1 := RECORD
    rec_orders;
    rec_stores;
  END;

  outrec1 Mytransf1(rec_orders Le, rec_stores Ri) := TRANSFORM
    SELF := Le;
    SELF := Ri;
  END;


  joineds1 := JOIN(orders,stores,LEFT.store_id=RIGHT.store_id, Mytransf1(LEFT, RIGHT), FULL OUTER);
  // OUTPUT(joineds1);

  outrec2 := RECORD
    outrec1;
    rec_hubs;
  END;

  outrec2 Mytransf2(outrec1 Le, rec_hubs Ri) := TRANSFORM
    SELF := Le;
    SELF := Ri;
  END;

  joineds2 := JOIN(joineds1,hubs,LEFT.hub_id=RIGHT.hub_id, Mytransf2(LEFT, RIGHT));
  // OUTPUT(joineds2);

  outrec3 := RECORD
    outrec2;
    rec_payments;
  END;

  outrec3 Mytransf3(outrec2 Le, rec_payments Ri) := TRANSFORM
    SELF := Le;
    SELF := Ri;
  END;

  joineds3 := JOIN(joineds2,payments,LEFT.payment_order_id=RIGHT.payment_order_id, Mytransf3(LEFT, RIGHT));
  // OUTPUT(joineds3);

  outrec4 := RECORD
    outrec3;
    rec_deliveries;
  END;

  outrec4 Mytransf4(outrec3 Le, rec_deliveries Ri) := TRANSFORM
    SELF := Le;
    SELF := Ri;
  END;

  joineds4 := JOIN(joineds3,deliveries,LEFT.delivery_order_id=RIGHT.delivery_order_id, Mytransf4(LEFT, RIGHT));
  // OUTPUT(joineds4);

  outrec5 := RECORD
    outrec4;
    rec_drivers;
  END;

  outrec5 Mytransf5(outrec4 Le, rec_drivers Ri) := TRANSFORM
    SELF := Le;
    SELF := Ri;
  END;

  joineds5 := JOIN(joineds4,drivers,LEFT.driver_id=RIGHT.driver_id, Mytransf5(LEFT, RIGHT));

  outrec6 := RECORD
    outrec5;
    rec_channels;
  END;

  outrec6 Mytransf6(outrec5 Le, rec_channels Ri) := TRANSFORM
    SELF := Le;
    SELF := Ri;
  END;

  EXPORT joineds := JOIN(joineds5,channels,LEFT.channel_id=RIGHT.channel_id, Mytransf6(LEFT, RIGHT));

  // joineds := JOIN(joineds1,channels,LEFT.channel_id=RIGHT.channel_id, Mytransf6(LEFT, RIGHT));

  // OUTPUT(joineds);

  EXPORT out := OUTPUT(joineds,, '~delivery_center::rgr::joined_dataset',overwrite);
END;
  