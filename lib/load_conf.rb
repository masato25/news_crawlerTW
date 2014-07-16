#funcation for read conf
def load_config_file(path)
  mod = Module.new
  mod.module_eval File.read(path)
  mod
end