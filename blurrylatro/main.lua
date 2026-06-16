--- STEAMODDED HEADER
--- MOD_NAME: blurrylatro
--- MOD_ID: blurrylatro
--- PREFIX: blurrylatro
--- MOD_AUTHOR: [footlongdingledong]
--- MOD_DESCRIPTION: balatro but blurry
--- VERSION: 1.0.1
--- DEPENDENCIES: [malverk]

AltTexture({
    key = 'blurry_joker',
  set = 'Joker',
    path = 'blurry_jokers.png',
  loc_txt = {
      name = 'Blurry Jokers'
  }
})
AltTexture({
    key = 'blurry_tarots',
  set = 'Tarot',
    path = 'blurry_tarots.png',
  loc_txt = {
      name = 'Blurry Tarots'
  }
})
AltTexture({
    key = 'blurry_planet',
  set = 'Planet',
    path = 'blurry_tarots.png',
  loc_txt = {
      name = 'Blurry Planets'
  }
})
AltTexture({
    key = 'blurry_spectral',
  set = 'Spectral',
    path = 'blurry_tarots.png',
    soul = 'blurry_decks.png',
  loc_txt = {
      name = 'Blurry Spectrals'
  }
})
AltTexture({
  key = 'blurry_enhance',
  set = 'Enhanced',
  path = 'blurry_decks.png',
  loc_txt = {
      name = 'Blurry Enhancements'
  }
})
AltTexture({
  key = 'blurry_seal',
  set = 'Seal',
  path = 'blurry_decks.png',
  loc_txt = {
      name = 'Blurry Seals'
  }
})
AltTexture({
  key = 'blurry_deck',
  set = 'Back',
  path = 'blurry_decks.png',
  loc_txt = {
      name = 'Blurry Decks'
  }
})
AltTexture({
  key = 'blurry_voucher',
  set = 'Voucher',
  path = 'blurry_vouchers.png',
  loc_txt = {
      name = 'Blurry Vouchers'
  }
})
AltTexture({
  key = 'blurry_booster',
  set = 'Booster',
  path = 'blurry_boosters.png',
  loc_txt = {
      name = 'Blurry Booster Packs'
  }
})
AltTexture({
  key = 'blurry_tag',
  set = 'Tag',
  path = 'blurry_tags.png',
  loc_txt = {
      name = 'Blurry Tags'
  }
})
AltTexture({
  key = 'blurry_blind',
  set = 'Blind',
  path = 'blurry_blinds.png',
  frames = 21,
  loc_txt = {
      name = 'Blurry Blinds'
  }
})
AltTexture({
  key = 'blurry_stake',
  set = 'Stake',
  path = 'blurry_stakes.png',
  loc_txt = {
      name = 'Blurry Stakes'
  }
})
AltTexture({
  key = 'blurry_sticker',
  set = 'Sticker',
  path = 'blurry_stickers.png',
  loc_txt = {
      name = 'Blurry Stickers'
  }
})
TexturePack({
  key = 'Blurrylatro',
  textures = {
      'blurrylatro_blurry_joker',
      'blurrylatro_blurry_tarots',
      'blurrylatro_blurry_planet',
      'blurrylatro_blurry_spectral',
      'blurrylatro_blurry_enhance',
      'blurrylatro_blurry_seal',
      'blurrylatro_blurry_deck',
      'blurrylatro_blurry_voucher',
      'blurrylatro_blurry_booster',
      'blurrylatro_blurry_tag',
      'blurrylatro_blurry_blind',
      'blurrylatro_blurry_stake',
      'blurrylatro_blurry_sticker',
  },
  loc_txt = {
      name = 'Blurrylatro',
      text = {'i cant see shit'}
  }
})

-- malverk only does the spritesheets so foil/holo/etc were still sharp lol
-- so just swap the shaders for blurry ones. names have to match what
-- card.lua uses so dont put a prefix on them

local blurrylatro_mod = SMODS.current_mod

local blurry_edition_shaders = {
    'dissolve', -- this is the actual card art under the edition (foil wouldnt blur without this)
    'foil',
    'holo',
    'polychrome',
    'negative',
    'negative_shine',
}

local function blurrylatro_read_file(path)
    -- nativefs to read the file, otherwise try love.filesystem i guess
    local nfs = NFS or (SMODS and SMODS.NFS)
    if not nfs then
        local ok, lib = pcall(require, 'nativefs')
        if ok then nfs = lib end
    end
    if nfs then
        local data = nfs.read(path)
        if data then return data end
    end
    local ok, data = pcall(love.filesystem.read, path)
    if ok and data then return data end
    return nil
end

local function blurrylatro_apply_shaders()
    if not (G and G.SHADERS) then return end
    if not (blurrylatro_mod and blurrylatro_mod.path) then return end

    for _, name in ipairs(blurry_edition_shaders) do
        local code = blurrylatro_read_file(blurrylatro_mod.path .. 'assets/shaders/' .. name .. '.fs')
        if code then
            local ok, shader = pcall(love.graphics.newShader, code)
            if ok and shader then
                G.SHADERS[name] = shader
            else
                sendWarnMessage('could not compile blurry "' .. name .. '" shader: ' .. tostring(shader), 'blurrylatro')
            end
        else
            sendWarnMessage('could not read shader file for "' .. name .. '"', 'blurrylatro')
        end
    end
end

-- redo it on start_up so it still works after a reload (alt f5)
local blurrylatro_start_up = Game.start_up
function Game:start_up(...)
    blurrylatro_start_up(self, ...)
    blurrylatro_apply_shaders()
end

-- and do it now too just in case
blurrylatro_apply_shaders()
