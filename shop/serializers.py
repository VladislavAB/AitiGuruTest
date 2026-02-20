from rest_framework import serializers


class AddItemSerializer(serializers.Serializer):
    nomenclature_id = serializers.IntegerField(min_value=1)
    quantity = serializers.IntegerField(min_value=1)


class AddItemResponseSerializer(serializers.Serializer):
    status = serializers.CharField(default="success")
    order_id = serializers.IntegerField()
    nomenclature_id = serializers.IntegerField()
    added_quantity = serializers.IntegerField()
