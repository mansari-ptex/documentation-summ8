unit const_for_change;

interface

  { constants }
  const MAX_USB_DEVICES = 128;                  { maximum number of USB devices that can be attached to the system at one time }
  const MAX_PRODCODE_LEN = 8;                   { maximum length of a Product Code }

  { mask values }
  const TYPE_MASK_PRO = 1;
  const TYPE_MASK_FD  = 2;
  const TYPE_MASK_ALL = TYPE_MASK_PRO or TYPE_MASK_FD;

  const MODEL_MASK_LITE    = 1;
  const MODEL_MASK_PLUS    = 2;
  const MODEL_MASK_NET     = 4;
  const MODEL_MASK_ALL	   = MODEL_MASK_LITE or MODEL_MASK_PLUS or MODEL_MASK_NET;
  const MODEL_MASK_DEFAULT = MODEL_MASK_PLUS or MODEL_MASK_NET;

  { type values (returned in the array) }
  const TYPE_PRO = 1;
  const TYPE_FD	 = 2;

  { model values (returned in the array) }
  const MODEL_LITE  = 1;
  const MODEL_PLUS  = 2;
  const MODEL_NET5  = 4;
  const MODEL_NETU  = 7;

  {$IFDEF WIN32}
  function DCDoUpdateCodeString(UpdateCodeString: PAnsiChar; confirmation_code, extended_error: PLongInt): LongInt; stdcall; external 'DinkeyChange.dll';
  {$ENDIF}
  {$IFDEF WIN64}
  function DCDoUpdateCodeString(UpdateCodeString: PAnsiChar; confirmation_code, extended_error: PLongInt): LongInt; stdcall; external 'DinkeyChange64.dll';
  {$ENDIF}

implementation

end.
