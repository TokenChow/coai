package billing

import "github.com/gin-gonic/gin"

// Register registers billing-related routes
func Register(app *gin.RouterGroup) {
	g := app.Group("/billing")
	_ = g
	// TODO: Add billing endpoints
}
