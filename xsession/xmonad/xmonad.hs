import XMonad
import XMonad.Actions.SpawnOn         (spawnOn, manageSpawn)
import XMonad.Actions.Volume          (lowerVolume, raiseVolume, toggleMute)
import XMonad.Actions.PhysicalScreens (viewScreen, sendToScreen)
import XMonad.Config.Desktop          (desktopConfig)
import XMonad.Config.Xfce             (xfceConfig)
import XMonad.Layout.Fullscreen       (fullscreenSupport)
import XMonad.Layout.NoBorders        (smartBorders)
import XMonad.Layout.Spacing          (spacingRaw, Border(Border), Spacing (smartBorder))
import Control.Monad                  (void)            
import qualified Data.Map as M
import GHC.Base (Bool(True))
import GHC.Types (Bool(True))
import XMonad.Config.Prime (Bool(True))
import Graphics.X11.ExtraTypes.XF86

main = do
    xmonad $ fullscreenSupport xfceConfig
        { modMask            = mod4Mask -- Use Super instead of Alt
        , terminal           = myTerminal
        , workspaces         = myWorkspaces
        , normalBorderColor  = myNormalBorderColor
        , focusedBorderColor = myFocusedBorderColor
        , layoutHook         = myLayoutHook
        , keys               = myKeys        <+> keys        desktopConfig
        , startupHook        = myStartupHook <+> startupHook xfceConfig
        , manageHook         = manageSpawn   <+> manageHook  xfceConfig
    }

-- layout
myLayoutHook = spacingRaw True             -- smartBorder  enabled
                          (Border 4 4 4 4) -- screenBorder 
                          True             -- screenBorder enabled
                          (Border 4 4 4 4) -- windowBorder 
                          True             -- windowBorder enabled
                          (smartBorders $ layoutHook xfceConfig)

-- keys
myKeys conf@XConfig {modMask = modm} = M.fromList $
    [ ((modm,                        xK_q  ), kill                        )
    , ((modm,                        xK_r  ), spawn restartXmonad         )
    , ((modm,                        xK_p  ), spawn dmenuCommand          )
    , ((modm,                        xK_c  ), spawn rofiCalc              )
    , ((modm,                        xK_v  ), spawn rofiWindow            )
    , ((modm        .|. shiftMask,   xK_p  ), spawn rofiDrun              )
    , ((modm        .|. shiftMask,   xK_s  ), spawn screenshotCommand     )
    , ((mod1Mask    .|. controlMask, xK_t  ), spawn $ XMonad.terminal conf)
    , ((mod1Mask    .|. controlMask, xK_f  ), spawn fileManager           )
    , ((mod1Mask    .|. controlMask, xK_l  ), spawn lockScreenCommand     )
    , ((controlMask,                 xK_F11), spawn brightnessDownBig     )
    , ((controlMask,                 xK_F12), spawn brightnessUpBig       )
    , ((controlMask .|. shiftMask,   xK_F11), spawn brightnessDownSmall   )
    , ((controlMask .|. shiftMask,   xK_F12), spawn brightnessUpSmall     )
    , ((0,         xF86XK_AudioMute        ), void   toggleMute           )
    , ((0,         xF86XK_AudioLowerVolume ), void $ lowerVolume 5        )
    , ((0,         xF86XK_AudioRaiseVolume ), void $ raiseVolume 5        )
    , ((controlMask .|. shiftMask,   xK_F2 ), void $ lowerVolume 1        )
    , ((controlMask .|. shiftMask,   xK_F3 ), void $ raiseVolume 1        )
    ] ++ physicalScreensKeys modm

-- screen configuration
physicalScreensKeys modm = 
    [ ((modm .|. mask, key), f sc) 
        | (key, sc) <- zip [xK_w, xK_e] [0..]
        , (f, mask) <- [(viewScreen def, 0), (sendToScreen def, shiftMask)]
    ]

-- commands
dmenuCommand        = "dmenu_run"
rofiDrun            = "rofi -show drun"
rofiWindow          = "rofi -show window"
rofiCalc            = "rofi -show calc"
screenshotCommand   = "xfce4-screenshooter -c -r "
restartXmonad       = "if type xmonad; then xmonad --recompile && xmonad --restart; else xmessage xmonad not in \\$PATH: \"$PATH\"; fi"
fileManager         = "thunar"
lockScreenCommand   = "light-locker-command --lock"
brightnessDownBig   = "brightnessctl --device=intel_backlight s 10%-"
brightnessUpBig     = "brightnessctl --device=intel_backlight s +10%"
brightnessDownSmall = "brightnessctl --device=intel_backlight s 1%-"
brightnessUpSmall   = "brightnessctl --device=intel_backlight s +1%"

--  workspaces
myWorkspaces = ["Main", "Side", "Notes", "Social", "Mail", "System"]

-- terminal
myTerminal = "alacritty"

-- colors
myNormalBorderColor = "#282A36"
myFocusedBorderColor = "#BD93F9"

-- startup
myStartupHook = do 
  -- necessary startup
  spawn "xfsettingsd"
  spawn "picom"
  spawn "polybar top --config=POLYBAR-CONFIG"
  spawn "dunst -conf DUNST-CONFIG"
  spawn "blueman-applet"
  spawn "nm-applet --sm-disable --indicator"
  spawn "xfce4-power-manager --daemon"
  spawn "light-locker"
  -- open applications on startup
  spawnOn "Main"   "firefox"
  spawnOn "Side"   "todoist-electron"
  spawnOn "Mail"   "thunderbird"

