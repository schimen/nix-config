import XMonad
import XMonad.Actions.SpawnOn   (spawnOn, manageSpawn)
import XMonad.Config.Desktop    (desktopConfig)
import XMonad.Config.Xfce       (xfceConfig)
import XMonad.Layout.Fullscreen (fullscreenSupport)
import XMonad.Layout.NoBorders  (smartBorders)
import XMonad.Layout.Spacing    (smartSpacingWithEdge)
import XMonad.Actions.Volume    (lowerVolume, raiseVolume, toggleMute)

import qualified Data.Map as M

main = do
    xmonad $ fullscreenSupport xfceConfig
        { modMask            = mod4Mask -- Use Super instead of Alt
        , terminal           = myTerminal
        , workspaces         = myWorkspaces
        , normalBorderColor  = myNormalBorderColor
        , focusedBorderColor = myFocusedBorderColor
	, layoutHook         = smartSpacingWithEdge 4 $ smartBorders $ layoutHook xfceConfig
        , keys               = myKeys        <+> keys desktopConfig
	--, startupHook        = myStartupHook <+> startupHook xfceConfig
        , manageHook         = manageSpawn   <+> manageHook  xfceConfig
	}

-- keys
myKeys conf@(XConfig {modMask = modm}) = M.fromList $
    [ ((modm,                        xK_p  ), spawn "dmenu_run")
    , ((modm        .|. shiftMask,   xK_p  ), spawn "rofi -show run")
    , ((modm        .|. shiftMask,   xK_s  ), spawn "xfce4-screenshooter -c -r")
    , ((modm,                        xK_c  ), spawn restartXmonad)
    , ((modm,                        xK_q  ), kill)
    , ((mod1Mask    .|. controlMask, xK_t  ), spawn $ XMonad.terminal conf)
    , ((mod1Mask    .|. controlMask, xK_f  ), spawn "thunar")
    , ((mod1Mask    .|. controlMask, xK_l  ), spawn "light-locker-command --lock")
    , ((controlMask,                 xK_F11), spawn "brightnessctl --device=intel_backlight s 10%-")
    , ((controlMask,                 xK_F12), spawn "brightnessctl --device=intel_backlight s +10%")
    , ((controlMask .|. shiftMask,   xK_F11), spawn "brightnessctl --device=intel_backlight s 1%-")
    , ((controlMask .|. shiftMask,   xK_F12), spawn "brightnessctl --device=intel_backlight s +1%")
    , ((controlMask,                 xK_F1 ), toggleMute     >> return ())
    , ((controlMask,                 xK_F2 ), lowerVolume 10 >> return ())
    , ((controlMask,                 xK_F3 ), raiseVolume 10 >> return ())
    , ((controlMask .|. shiftMask,   xK_F2 ), lowerVolume 1  >> return ())
    , ((controlMask .|. shiftMask,   xK_F3 ), raiseVolume 1  >> return ())

    ]

-- restart command
restartXmonad = "if type xmonad; then xmonad --recompile && xmonad --restart; else xmessage xmonad not in \\$PATH: \"$PATH\"; fi"

--  workspaces
myWorkspaces = ["Main", "Side", "Notes", "Social", "Mail", "System"]

-- terminal
myTerminal = "xfce4-terminal"

-- colors
myNormalBorderColor = "#282A36"
myFocusedBorderColor = "#BD93F9"

-- startup applications
{-
myStartupHook = do 
         spawn "xfsettingsd"
	 spawn "xfce4-panel"
	 spawn "thunar --daemon"
	 spawn "blueman-applet"
	 spawn "nm-applet"
	 spawn "xfce4-power-manager"
	 spawn "system-config-printer-applet"
	 spawn "pulseeffects --gapplication-service"
	 spawn "light-locker"
	 spawn "xdg-user-dirs-update"
	 --spawnOn "Main"   "firefox"
	 --spawnOn "Notes"  "obsidian"
	 --spawnOn "Mail"   "thunderbird"
         --spawnOn "Social" "discord"
-}
