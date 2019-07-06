PaGlobal_ServantSummonBoss = {
  _ui = {
    _stc_progressBG = nil,
    _stc_progressBar = nil,
    _stc_commandBG = nil,
    _stc_moveTitle = nil,
    _stc_attackTitle = nil,
    _moveList = {},
    _attackList = {},
    _txt_hp = nil
  },
  _bossInfo = {
    [1] = {
      _actorkey = 29880,
      _moveText = {
        [1] = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANTSUMMONBOSS_COMMAND_MOVE_BASIC"),
        [2] = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANTSUMMONBOSS_COMMAND_MOVE_FRONTRUN")
      },
      _attackText = {
        [1] = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANTSUMMONBOSS_COMMAND_ATTACK_BASIC"),
        [2] = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANTSUMMONBOSS_COMMAND_ATTACK_FOOT"),
        [3] = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANTSUMMONBOSS_COMMAND_ATTACK_JUMP"),
        [4] = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANTSUMMONBOSS_COMMAND_ATTACK_RUN"),
        [5] = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANTSUMMONBOSS_COMMAND_ATTACK_STOMACH")
      }
    },
    [2] = {
      _actorkey = 29800,
      _moveText = {
        [1] = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANTSUMMONBOSS_COMMAND_MOVE_BASIC"),
        [2] = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANTSUMMONBOSS_COMMAND_MOVE_FRONTRUN")
      },
      _attackText = {
        [1] = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANTSUMMONBOSS_COMMAND_ATTACK_BASIC"),
        [2] = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANTSUMMONBOSS_COMMAND_ATTACK_FOOT"),
        [3] = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANTSUMMONBOSS_COMMAND_ATTACK_JUMP"),
        [4] = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANTSUMMONBOSS_COMMAND_ATTACK_RUN"),
        [5] = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANTSUMMONBOSS_COMMAND_ATTACK_STOMACH")
      }
    },
    [3] = {
      _actorkey = 29805,
      _moveText = {
        [1] = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANTSUMMONBOSS_COMMAND_MOVE_BASIC"),
        [2] = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANTSUMMONBOSS_COMMAND_MOVE_FRONTRUN"),
        [3] = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANTSUMMONBOSS_COMMAND_MOVE_DASH")
      },
      _attackText = {
        [1] = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANTSUMMONBOSS_COMMAND_ATTACK_BASIC"),
        [2] = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANTSUMMONBOSS_COMMAND_ATTACK_FOOT"),
        [3] = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANTSUMMONBOSS_COMMAND_ATTACK_JUMP"),
        [4] = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANTSUMMONBOSS_COMMAND_ATTACK_RUN"),
        [5] = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANTSUMMONBOSS_COMMAND_ATTACK_PROMPTLY")
      }
    },
    [4] = {
      _actorkey = 29806,
      _moveText = {
        [1] = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANTSUMMONBOSS_COMMAND_MOVE_BASIC"),
        [2] = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANTSUMMONBOSS_COMMAND_MOVE_FRONTRUN"),
        [3] = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANTSUMMONBOSS_COMMAND_MOVE_BASEATTACK")
      },
      _attackText = {
        [1] = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANTSUMMONBOSS_COMMAND_ATTACK_BASIC"),
        [2] = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANTSUMMONBOSS_COMMAND_ATTACK_DOWNWARD"),
        [3] = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANTSUMMONBOSS_COMMAND_ATTACK_RUN"),
        [4] = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANTSUMMONBOSS_COMMAND_ATTACK_TAPPING_FOOT")
      }
    }
  },
  _MAX_MOVE_COUNT = 3,
  _MAX_ATTACK_COUNT = 5,
  _isShowSkillCommand = false,
  _initialize = false
}
runLua("UI_Data/Script/Window/Servant/Panel_Widget_ServantSummonBoss_1.lua")
runLua("UI_Data/Script/Window/Servant/Panel_Widget_ServantSummonBoss_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_PaGlobal_ServantSummonBossInit")
function FromClient_PaGlobal_ServantSummonBossInit()
  PaGlobal_ServantSummonBoss:initialize()
end
