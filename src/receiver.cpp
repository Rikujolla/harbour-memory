// Copyright (C) 2017 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

#include <QUdpSocket>
//#include <QCoreApplication>

#include "receiver.h"

Receiver::Receiver()

{
    //! [0]
    udpSocket = new QUdpSocket(this);
    udpSocket->bind(45454, QUdpSocket::ShareAddress);
    //! [0]

    //! [1]
    connect(udpSocket, &QUdpSocket::readyRead,
            this, &Receiver::processPendingDatagrams);
    //! [1]
}

void Receiver::startReceiver()
{
    processPendingDatagrams();
}

void Receiver::processPendingDatagrams()
{
    QByteArray datagram;
    //! [2]
    while (udpSocket->hasPendingDatagrams()) {
        datagram.resize(int(udpSocket->pendingDatagramSize()));
        udpSocket->readDatagram(datagram.data(), datagram.size());
        qDebug() << (tr("Received datagram: \"%1\"")
                             .arg(datagram.constData()));
    }
    //! [2]
}
