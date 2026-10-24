Add-Type -AssemblyName System.Drawing

$width = 1100
$height = 680
$bmp = New-Object System.Drawing.Bitmap $width, $height, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [System.Drawing.Graphics]::FromImage($bmp)

$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

# 1. Studio Dark Background with Radial Vignette
$rectBg = New-Object System.Drawing.Rectangle 0, 0, $width, $height
$brushBg = New-Object System.Drawing.Drawing2D.LinearGradientBrush (New-Object System.Drawing.Point 0, 0), (New-Object System.Drawing.Point 0, $height), ([System.Drawing.Color]::FromArgb(255, 15, 13, 10)), ([System.Drawing.Color]::FromArgb(255, 7, 6, 5))
$g.FillRectangle($brushBg, $rectBg)
$brushBg.Dispose()

# Ambient UV & Gold Glows
$pathUvGlow = New-Object System.Drawing.Drawing2D.GraphicsPath
$pathUvGlow.AddEllipse(180, 80, 740, 500)
$brushUv = New-Object System.Drawing.Drawing2D.PathGradientBrush $pathUvGlow
$brushUv.CenterColor = [System.Drawing.Color]::FromArgb(50, 157, 78, 221)
$brushUv.SurroundColors = @([System.Drawing.Color]::FromArgb(0, 7, 6, 5))
$g.FillPath($brushUv, $pathUvGlow)
$pathUvGlow.Dispose()
$brushUv.Dispose()

$pathGoldGlow = New-Object System.Drawing.Drawing2D.GraphicsPath
$pathGoldGlow.AddEllipse(300, 150, 500, 380)
$brushGold = New-Object System.Drawing.Drawing2D.PathGradientBrush $pathGoldGlow
$brushGold.CenterColor = [System.Drawing.Color]::FromArgb(60, 240, 210, 139)
$brushGold.SurroundColors = @([System.Drawing.Color]::FromArgb(0, 7, 6, 5))
$g.FillPath($brushGold, $pathGoldGlow)
$pathGoldGlow.Dispose()
$brushGold.Dispose()

# Ground Contact Shadow
$pathShadow = New-Object System.Drawing.Drawing2D.GraphicsPath
$pathShadow.AddEllipse(100, 570, 900, 80)
$brushShadow = New-Object System.Drawing.Drawing2D.PathGradientBrush $pathShadow
$brushShadow.CenterColor = [System.Drawing.Color]::FromArgb(230, 0, 0, 0)
$brushShadow.SurroundColors = @([System.Drawing.Color]::FromArgb(0, 0, 0, 0))
$g.FillPath($brushShadow, $pathShadow)
$pathShadow.Dispose()
$brushShadow.Dispose()

function Get-RoundedRectPath($rect, $r) {
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $d = $r * 2
    $path.AddArc($rect.X, $rect.Y, $d, $d, 180, 90)
    $path.AddArc($rect.Right - $d, $rect.Y, $d, $d, 270, 90)
    $path.AddArc($rect.Right - $d, $rect.Bottom - $d, $d, $d, 0, 90)
    $path.AddArc($rect.X, $rect.Bottom - $d, $d, $d, 90, 90)
    $path.CloseFigure()
    return $path
}

# 2. Folhas Antigas do Manuscrito (Left Side)
$state1 = $g.Save()
$g.TranslateTransform(220, 360)
$g.RotateTransform(-12)

# Sheet 2 (Underneath)
$p2Rect = New-Object System.Drawing.Rectangle -140, -210, 250, 350
$brushP2 = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(240, 200, 170, 125))
$penP2 = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(180, 140, 105, 60)), 1.5
$g.FillRectangle($brushP2, $p2Rect)
$g.DrawRectangle($penP2, $p2Rect)
$brushP2.Dispose()
$penP2.Dispose()

# Sheet 1 (Top Ancient Parchment)
$g.RotateTransform(5)
$p1Rect = New-Object System.Drawing.Rectangle -145, -215, 250, 350
$brushP1 = New-Object System.Drawing.Drawing2D.LinearGradientBrush (New-Object System.Drawing.Point -145, -215), (New-Object System.Drawing.Point 105, 135), ([System.Drawing.Color]::FromArgb(255, 245, 230, 195)), ([System.Drawing.Color]::FromArgb(255, 215, 185, 140))
$penP1 = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(210, 160, 120, 70)), 2
$g.FillRectangle($brushP1, $p1Rect)
$g.DrawRectangle($penP1, $p1Rect)
$brushP1.Dispose()
$penP1.Dispose()

# Ornamental border
$penGoldBorder = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(180, 160, 120, 50)), 1
$g.DrawRectangle($penGoldBorder, -135, -205, 230, 330)
$penGoldBorder.Dispose()

# Faux manuscript text lines
$penInk = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(140, 90, 60, 35)), 1.5
for ($ly = -140; $ly -le 90; $ly += 16) {
    $lw = if ($ly -ge 70) { 140 } else { 210 }
    $g.DrawLine($penInk, -125, $ly, (-125 + $lw), $ly)
}
$penInk.Dispose()

# Header on parchment
$fontParchTitle = New-Object System.Drawing.Font "Georgia", ([float]10), [System.Drawing.FontStyle]::Bold
$fontParchSub = New-Object System.Drawing.Font "Georgia", ([float]7.5), [System.Drawing.FontStyle]::Italic
$brushRedInk = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(220, 140, 35, 30))
$brushDarkInk = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(220, 70, 45, 20))
$g.DrawString("+ PALIMPSESTO SIRIACO +", $fontParchTitle, $brushRedInk, -125, -195)
$g.DrawString("O Segredo Oculto de Mateus 11:28", $fontParchSub, $brushDarkInk, -125, -172)
$brushRedInk.Dispose()
$brushDarkInk.Dispose()
$fontParchTitle.Dispose()
$fontParchSub.Dispose()

$g.Restore($state1)

# 3. Central iPad Tablet (with authentic book cover)
$tabX = 350
$tabY = 55
$tabW = 390
$tabH = 540
$tabRadius = 24
$bezel = 13

# Outer Tablet Bezel
$tabOuterRect = New-Object System.Drawing.Rectangle $tabX, $tabY, $tabW, $tabH
$tabOuterPath = Get-RoundedRectPath $tabOuterRect $tabRadius
$tabOuterBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush (New-Object System.Drawing.Point $tabX, $tabY), (New-Object System.Drawing.Point ($tabX + $tabW), ($tabY + $tabH)), ([System.Drawing.Color]::FromArgb(255, 65, 60, 55)), ([System.Drawing.Color]::FromArgb(255, 18, 17, 16))
$g.FillPath($tabOuterBrush, $tabOuterPath)
$tabOuterBrush.Dispose()

# Metallic Edge Highlight
$penMetal = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(230, 212, 175, 55)), 2
$g.DrawPath($penMetal, $tabOuterPath)
$penMetal.Dispose()
$tabOuterPath.Dispose()

# Inner Screen
$screenX = $tabX + $bezel
$screenY = $tabY + $bezel
$screenW = $tabW - ($bezel * 2)
$screenH = $tabH - ($bezel * 2)
$screenRect = New-Object System.Drawing.Rectangle $screenX, $screenY, $screenW, $screenH
$screenPath = Get-RoundedRectPath $screenRect ($tabRadius - 6)

$stateScreen = $g.Save()
$g.SetClip($screenPath)

$coverImg = [System.Drawing.Image]::FromFile((Resolve-Path "capa-livro.jpg").Path)
$g.DrawImage($coverImg, $screenRect)
$coverImg.Dispose()

# Diagonal Glass Reflection Glare
$glarePath = New-Object System.Drawing.Drawing2D.GraphicsPath
$glarePath.AddPolygon(@(
    (New-Object System.Drawing.Point $screenX, $screenY),
    (New-Object System.Drawing.Point ($screenX + 200), $screenY),
    (New-Object System.Drawing.Point $screenX, ($screenY + 400))
))
$glareBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush (New-Object System.Drawing.Point $screenX, $screenY), (New-Object System.Drawing.Point ($screenX + 150), ($screenY + 280)), ([System.Drawing.Color]::FromArgb(60, 255, 255, 255)), ([System.Drawing.Color]::FromArgb(0, 255, 255, 255))
$g.FillPath($glareBrush, $glarePath)
$glarePath.Dispose()
$glareBrush.Dispose()

$g.Restore($stateScreen)
$screenPath.Dispose()

# Camera Dot
$brushCam = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(220, 10, 10, 10))
$g.FillEllipse($brushCam, [int]($tabX + $tabW / 2 - 3), [int]($tabY + 5), 6, 6)
$brushCam.Dispose()

# 4. Modern Studio Headphones (Right Side)
$stateHp = $g.Save()
$g.TranslateTransform(870, 310)
$g.RotateTransform(6)

# Headband Arc Shadow & Body
$penHeadband = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(255, 28, 26, 24)), 16
$penHeadband.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
$penHeadband.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
$g.DrawArc($penHeadband, -100, -140, 200, 180, 195, 150)
$penHeadband.Dispose()

# Headband Gold Accent
$penHbGold = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(220, 212, 175, 55)), 4
$g.DrawArc($penHbGold, -100, -140, 200, 180, 225, 90)
$penHbGold.Dispose()

# Earcups (L and R)
$penCupGold = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(230, 212, 175, 55)), 2.5

# Left Cup
$brushCupL = New-Object System.Drawing.Drawing2D.LinearGradientBrush (New-Object System.Drawing.Point -120, -15), (New-Object System.Drawing.Point -60, 85), ([System.Drawing.Color]::FromArgb(255, 45, 42, 40)), ([System.Drawing.Color]::FromArgb(255, 18, 17, 16))
$g.FillEllipse($brushCupL, -120, -15, 55, 95)
$g.DrawEllipse($penCupGold, -120, -15, 55, 95)
$brushCupL.Dispose()

# Right Cup
$brushCupR = New-Object System.Drawing.Drawing2D.LinearGradientBrush (New-Object System.Drawing.Point 65, -15), (New-Object System.Drawing.Point 125, 85), ([System.Drawing.Color]::FromArgb(255, 45, 42, 40)), ([System.Drawing.Color]::FromArgb(255, 18, 17, 16))
$g.FillEllipse($brushCupR, 65, -15, 55, 95)
$g.DrawEllipse($penCupGold, 65, -15, 55, 95)
$penCupGold.Dispose()
$brushCupR.Dispose()

$g.Restore($stateHp)

# 5. Glowing 432Hz Audio Bonus Badge
$badgeX = 760
$badgeY = 395
$badgeW = 285
$badgeH = 115
$badgeRect = New-Object System.Drawing.Rectangle $badgeX, $badgeY, $badgeW, $badgeH
$badgePath = Get-RoundedRectPath $badgeRect 16

$badgeBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush (New-Object System.Drawing.Point $badgeX, $badgeY), (New-Object System.Drawing.Point ($badgeX + $badgeW), ($badgeY + $badgeH)), ([System.Drawing.Color]::FromArgb(250, 26, 20, 36)), ([System.Drawing.Color]::FromArgb(250, 12, 10, 15))
$g.FillPath($badgeBrush, $badgePath)
$badgeBrush.Dispose()

$badgePen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(220, 157, 78, 221)), 2
$g.DrawPath($badgePen, $badgePath)
$badgePen.Dispose()

$fontTag = New-Object System.Drawing.Font "Arial", ([float]8), [System.Drawing.FontStyle]::Bold
$fontTitle = New-Object System.Drawing.Font "Georgia", ([float]11.5), [System.Drawing.FontStyle]::Bold
$fontSub = New-Object System.Drawing.Font "Arial", ([float]8.5), [System.Drawing.FontStyle]::Regular
$fontDesc = New-Object System.Drawing.Font "Arial", ([float]7.5), [System.Drawing.FontStyle]::Italic

$brushGoldText = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 240, 210, 139))
$brushUvText = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 180, 120, 245))
$brushWhiteText = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(240, 240, 240, 240))
$brushMutedText = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(180, 180, 180))

$g.DrawString("BONUS EXCLUSIVO INCLUSO", $fontTag, $brushUvText, ($badgeX + 16), ($badgeY + 14))
$g.DrawString("AUDIO FREQUENCIA 432Hz", $fontTitle, $brushGoldText, ($badgeX + 16), ($badgeY + 32))
$g.DrawString("Oracao Original Subliminar (MP3)", $fontSub, $brushWhiteText, ($badgeX + 16), ($badgeY + 60))
$g.DrawString("Ouvir antes de dormir para destravar a mente", $fontDesc, $brushMutedText, ($badgeX + 16), ($badgeY + 82))

# Soundwaves
$penWave = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(220, 240, 210, 139)), 2
$waves = @(6, 14, 24, 16, 28, 20, 12, 6)
for ($w = 0; $w -lt $waves.Length; $w++) {
    $wx = $badgeX + 245 + ($w * 4)
    $wy = $badgeY + 45
    $wh = $waves[$w]
    $g.DrawLine($penWave, $wx, [int]($wy - $wh/2), $wx, [int]($wy + $wh/2))
}
$penWave.Dispose()

$fontTag.Dispose()
$fontTitle.Dispose()
$fontSub.Dispose()
$fontDesc.Dispose()
$brushGoldText.Dispose()
$brushUvText.Dispose()
$brushWhiteText.Dispose()
$brushMutedText.Dispose()
$badgePath.Dispose()

# 6. Top Ribbon Banner
$ribbonRect = New-Object System.Drawing.Rectangle 350, 16, 400, 32
$ribbonPath = Get-RoundedRectPath $ribbonRect 16
$ribbonBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush (New-Object System.Drawing.Point 350, 16), (New-Object System.Drawing.Point 750, 48), ([System.Drawing.Color]::FromArgb(250, 212, 175, 55)), ([System.Drawing.Color]::FromArgb(250, 175, 130, 35))
$g.FillPath($ribbonBrush, $ribbonPath)
$ribbonBrush.Dispose()

$fontRibbon = New-Object System.Drawing.Font "Georgia", ([float]8.5), [System.Drawing.FontStyle]::Bold
$brushRibbonText = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 12, 10, 8))
$sf = New-Object System.Drawing.StringFormat
$sf.Alignment = [System.Drawing.StringAlignment]::Center
$sf.LineAlignment = [System.Drawing.StringAlignment]::Center
$g.DrawString("+ PACOTE COMPLETO DIGITAL - ACESSO IMEDIATO +", $fontRibbon, $brushRibbonText, (New-Object System.Drawing.RectangleF 350, 16, 400, 32), $sf)
$sf.Dispose()
$fontRibbon.Dispose()
$brushRibbonText.Dispose()
$ribbonPath.Dispose()

# 7. Bottom Checklist
$fontFoot = New-Object System.Drawing.Font "Arial", ([float]9), [System.Drawing.FontStyle]::Bold
$brushGoldFoot = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 240, 210, 139))
$footY = 635
$g.DrawString("[v] Guia Digital em PDF", $fontFoot, $brushGoldFoot, 180, $footY)
$g.DrawString("[v] Audio Original 432Hz", $fontFoot, $brushGoldFoot, 440, $footY)
$g.DrawString("[v] Celular, Tablet e Computador", $fontFoot, $brushGoldFoot, 690, $footY)

$fontFoot.Dispose()
$brushGoldFoot.Dispose()

$outPath = (Resolve-Path ".").Path + "\mockup-produto.png"
$bmp.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)

$g.Dispose()
$bmp.Dispose()
Write-Host "SUCESSO: Mockup gerado em $outPath"
