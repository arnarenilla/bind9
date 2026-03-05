#!/bin/bash

echo "====================================="
echo " BIND Validation + Safe Reload Script"
echo "====================================="

# Define zones
FORWARD_ZONE="jkxprod.lab"
FORWARD_FILE="/etc/bind/zones/jkxprod.lab"

REVERSE_ZONE="90.168.192.in-addr.arpa"
REVERSE_FILE="/etc/bind/zones/192.168.90.rev"

echo ""
echo "1️⃣ Checking named configuration..."
sudo named-checkconf
if [ $? -ne 0 ]; then
    echo "❌ named.conf has errors. Aborting."
    exit 1
fi
echo "✅ named.conf OK"

echo ""
echo "2️⃣ Checking forward zone..."
sudo named-checkzone $FORWARD_ZONE $FORWARD_FILE
if [ $? -ne 0 ]; then
    echo "❌ Forward zone failed. Aborting."
    exit 1
fi
echo "✅ Forward zone OK"

echo ""
echo "3️⃣ Checking reverse zone..."
sudo named-checkzone $REVERSE_ZONE $REVERSE_FILE
if [ $? -ne 0 ]; then
    echo "❌ Reverse zone failed. Aborting."
    exit 1
fi
echo "✅ Reverse zone OK"

echo ""
echo "4️⃣ Reloading BIND..."
sudo rndc reload
if [ $? -ne 0 ]; then
    echo "❌ Reload failed."
    exit 1
fi

echo ""
echo "🎉 SUCCESS: All checks passed and BIND reloaded safely!"
echo "====================================="
