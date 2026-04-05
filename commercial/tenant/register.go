package tenant

import "github.com/gin-gonic/gin"

// Register registers multi-tenant related routes
func Register(app *gin.RouterGroup) {
	g := app.Group("/tenant")
	_ = g
	// TODO: Add tenant management endpoints
}
