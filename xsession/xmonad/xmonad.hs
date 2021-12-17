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

main = do
    xmonad $ fullscreenSupport xfceConfig
        { modMask            = mod4Mask -- Use Super instead of Alt
        , terminal           = myTerminal
        , workspaces         = myWorkspaces
        , normalBorderColor  = myNormalBorderColor
        , focusedBorderColor = myFocusedBorderColor
        , layoutHook         = myLayoutHook
        , keys               = myKeys      <+> keys        desktopConfig
        , manageHook         = manageSpawn <+> manageHook  xfceConfig
    }

myLayoutHook = spacingRaw True             -- smartBorder  enabled
                          (Border 1 2 3 4) -- screenBorder 
                          True             -- screenBorder enabled
                          (Border 1 2 3 4) -- windowBorder 
                          True             -- windowBorder enabled
                          (smartBorders $ layoutHook xfceConfig)


-- keys
myKeys conf@XConfig {modMask = modm} = M.fromList $
    [ ((modm,                        xK_q  ), kill                        )
    , ((modm,                        xK_r  ), spawn restartXmonad         )
    , ((modm,                        xK_p  ), spawn dmenuCommand          )
    , ((modm,                        xK_c  ), spawn rofiCalc              )
    , ((modm,                        xK_w  ), spawn rofiWindow            )
    , ((modm        .|. shiftMask,   xK_p  ), spawn rofiDrun              )
    , ((modm        .|. shiftMask,   xK_s  ), spawn screenshotCommand     )
    , ((mod1Mask    .|. controlMask, xK_t  ), spawn $ XMonad.terminal conf)
    , ((mod1Mask    .|. controlMask, xK_f  ), spawn fileManager           )
    , ((mod1Mask    .|. controlMask, xK_l  ), spawn lockScreenCommand     )
    , ((controlMask,                 xK_F11), spawn brightnessDownBig     )
    , ((controlMask,                 xK_F12), spawn brightnessUpBig       )
    , ((controlMask .|. shiftMask,   xK_F11), spawn brightnessDownSmall   )
    , ((controlMask .|. shiftMask,   xK_F12), spawn brightnessUpSmall     )
    , ((controlMask,                 xK_F1 ), void   toggleMute           )
    , ((controlMask,                 xK_F2 ), void $ lowerVolume 10       )
    , ((controlMask,                 xK_F3 ), void $ raiseVolume 10       )
    , ((controlMask .|. shiftMask,   xK_F2 ), void $ lowerVolume 1        )
    , ((controlMask .|. shiftMask,   xK_F3 ), void $ raiseVolume 1        )
    ] ++ physicalScreensKeys modm

physicalScreensKeys modm = 
    [ ((modm .|. mask, key), f sc) 
        | (key, sc) <- zip [xK_w, xK_e] [0..]
        , (f, mask) <- [(viewScreen def, 0), (sendToScreen def, shiftMask)]
    ]

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
brightnessUpSmall   = "brightnessctl --device=intel_backlight s +1%-"

--  workspaces
myWorkspaces = ["Main", "Side", "Notes", "Social", "Mail", "System"]

-- terminal
myTerminal = "xfce4-terminal"

-- colors
myNormalBorderColor = "#282A36"
myFocusedBorderColor = "#BD93F9"