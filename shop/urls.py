from django.urls import path
from .views import AddItemToOrderView

urlpatterns = [
    path('orders/<int:order_id>/items/', AddItemToOrderView.as_view()),
]