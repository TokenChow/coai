package commercial

import (
	"chat/globals"
	"fmt"
	"os"

	"github.com/spf13/viper"
)

var commercialConfig = "config/commercial.yaml"

// InitConfig loads commercial-specific configuration
// Merges commercial.yaml into the main viper instance
// [COMMERCIAL] Commercial config is loaded separately to avoid upstream conflicts
func InitConfig() {
	if _, err := os.Stat(commercialConfig); os.IsNotExist(err) {
		globals.Info("[commercial] no commercial.yaml found, skipping commercial config")
		return
	}

	v := viper.New()
	v.SetConfigFile(commercialConfig)
	if err := v.ReadInConfig(); err != nil {
		globals.Warn(fmt.Sprintf("[commercial] failed to read commercial config: %s", err.Error()))
		return
	}

	// Merge commercial config into main viper under "commercial" namespace
	for k, val := range v.AllSettings() {
		viper.Set(fmt.Sprintf("commercial.%s", k), val)
	}

	globals.Info("[commercial] commercial config loaded successfully")
}
