package analytics

import "github.com/gin-gonic/gin"

// Register registers analytics-related routes
func Register(app *gin.RouterGroup) {
	g := app.Group("/analytics")
	_ = g
	// TODO: Add analytics endpoints
}
