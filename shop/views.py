from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from django.db import transaction
from django.shortcuts import get_object_or_404
from django.core.exceptions import ObjectDoesNotExist

from .models import Order, OrderItem, Nomenclature
from .serializers import AddItemSerializer


class AddItemToOrderView(APIView):
    def post(self, request, order_id):
        serializer = AddItemSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        nomenclature_id = serializer.validated_data['nomenclature_id']
        quantity = serializer.validated_data['quantity']

        with transaction.atomic():
            order = get_object_or_404(Order, id=order_id)

            nomenclature = get_object_or_404(Nomenclature, id=nomenclature_id)

            if nomenclature.stock_qty < quantity:
                return Response(
                    {"error": f"Недостаточно товара. В наличии: {nomenclature.stock_qty}"},
                    status=status.HTTP_400_BAD_REQUEST)

            try:
                item = OrderItem.objects.get(order=order, nomenclature=nomenclature)
                item.quantity += quantity
                item.save()
            except ObjectDoesNotExist:
                OrderItem.objects.create(
                    order=order,
                    nomenclature=nomenclature,
                    quantity=quantity,
                    price=nomenclature.price)

            nomenclature.stock_qty -= quantity
            nomenclature.save()

        response_data = {
            "status": "success",
            "order_id": order.id,
            "nomenclature_id": nomenclature.id,
            "added_quantity": quantity}

        return Response(response_data, status=status.HTTP_201_CREATED)