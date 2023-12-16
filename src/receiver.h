// Copyright (C) 2017 The Qt Company Ltd.
// BSD-3-Clause

#ifndef RECEIVER_H
#define RECEIVER_H

#include <QObject>


QT_BEGIN_NAMESPACE
//class QLabel;
class QUdpSocket;
QT_END_NAMESPACE

class Receiver : public QObject
{
    Q_OBJECT

public:
    explicit Receiver();
    Q_INVOKABLE void startReceiver();

private slots:
    void processPendingDatagrams();

private:
//    QLabel *statusLabel = nullptr;
    QUdpSocket *udpSocket = nullptr;
};

#endif
