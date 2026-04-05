package commercial

import (
	"chat/commercial/analytics"
	"chat/commercial/billing"
	"chat/commercial/tenant"

	"github.com/gin-gonic/gin"
)

// Register registers all commercial API routes
// [COMMERCIAL] This is the commercial extension entry point
func Register(app *gin.RouterGroup) {
	commercial := app.Group("/commercial")
	{
		billing.Register(commercial)
		tenant.Register(commercial)
		analytics.Register(commercial)
	}
}
